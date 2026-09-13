import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Tapping a search result opens its chapter', (
    WidgetTester tester,
  ) async {
    await pumpAndLoadAsyncContent(tester, const BookReaderApp());

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'التجويد');
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    // Should have navigated away from the search field.
    expect(find.byType(TextField), findsNothing);
  });
}
