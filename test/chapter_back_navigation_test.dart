import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';
import 'package:bookreader_app/widgets/book_card.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Back button returns from a chapter reader to the TOC', (
    WidgetTester tester,
  ) async {
    await pumpAndLoadAsyncContent(tester, const BookReaderApp());

    await tester.tap(find.byType(BookHeroCard).first);
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('1.', findRichText: true).first);
    await tester.pumpAndSettle();
    expect(find.text('محتويات الكتاب'), findsNothing);

    final backButton = find.byType(BackButton);
    expect(backButton, findsOneWidget);

    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(find.text('محتويات الكتاب'), findsOneWidget);
  });
}
