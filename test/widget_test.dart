import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Home screen loads the bundled book and shows its chapters', (
    WidgetTester tester,
  ) async {
    await pumpAndLoadAsyncContent(tester, const BookReaderApp());

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
