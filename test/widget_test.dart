import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';

void main() {
  testWidgets('Home screen loads the bundled book and shows its chapters', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BookReaderApp());
    await tester.pumpAndSettle();

    expect(find.text('المتمم المفيد'), findsWidgets);
    expect(find.text('ابدأ القراءة'), findsOneWidget);
    expect(find.text('محتويات الكتاب'), findsOneWidget);
    expect(
      find.textContaining('مقدمة الكتاب', findRichText: true),
      findsOneWidget,
    );
    expect(find.byType(Directionality), findsWidgets);
  });
}
