import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [widget] and waits for its real asset-based data (e.g. the bundled
/// book.json) to finish loading. `pumpAndSettle` alone isn't reliable here:
/// `rootBundle.loadString` needs real event-loop time that the fake test
/// clock advanced by `pump()` doesn't provide for larger assets, so the
/// load has to happen inside `runAsync`.
Future<void> pumpAndLoadAsyncContent(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(widget);
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
  await tester.pump();
  await tester.pumpAndSettle();
}
