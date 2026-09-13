import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';

void main() {
  testWidgets('Tapping the list icon navigates to the TOC screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BookReaderApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('محتويات الكتاب'), findsOneWidget);
    expect(find.text('ابدأ القراءة'), findsNothing);
  });
}
