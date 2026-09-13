import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';
import 'package:bookreader_app/widgets/book_card.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Library screen shows a card for every bundled book', (
    WidgetTester tester,
  ) async {
    await pumpAndLoadAsyncContent(tester, const BookReaderApp());

    expect(find.text('المكتبة'), findsOneWidget);
    expect(find.byType(BookHeroCard), findsNWidgets(2));
    expect(find.text('المدخل إلى علم التجويد'), findsOneWidget);
    expect(find.text('المتمم المفيد'), findsOneWidget);
    expect(find.text('ابدأ القراءة'), findsNWidgets(2));
    expect(find.byType(Directionality), findsWidgets);
  });
}
