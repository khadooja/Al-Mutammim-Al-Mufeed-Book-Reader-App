import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';
import 'package:bookreader_app/widgets/book_card.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Search from a book\'s TOC opens the matching chapter', (
    WidgetTester tester,
  ) async {
    await pumpAndLoadAsyncContent(tester, const BookReaderApp());

    // Search is per-book, so it's reached from inside a book, not the library.
    await tester.tap(find.byType(BookHeroCard).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'التجويد');
    await tester.pump();

    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    // Should have navigated away from the search field into the reader.
    expect(find.byType(TextField), findsNothing);
  });
}
