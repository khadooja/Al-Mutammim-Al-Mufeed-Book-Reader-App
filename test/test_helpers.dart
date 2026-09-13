import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [widget] and waits for its real asset-based data (the bundled
/// book JSON) to finish loading.
///
/// `pumpAndSettle` alone isn't enough here: `rootBundle.loadString` needs
/// real event-loop time that the fake test clock advanced by `pump()`
/// doesn't provide, so the load has to progress inside `runAsync`. The wait
/// polls for the loading spinner to disappear rather than sleeping a fixed
/// amount, since how long the load takes scales with how much content is
/// bundled (the library loads every book).
Future<void> pumpAndLoadAsyncContent(
  WidgetTester tester,
  Widget widget, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  await tester.pumpWidget(widget);

  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();
    if (find.byType(CircularProgressIndicator).evaluate().isEmpty) break;
  }

  await tester.pumpAndSettle();
}
