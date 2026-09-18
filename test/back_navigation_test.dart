import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';
import 'package:bookreader_app/widgets/book_card.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Back button returns from a book\'s TOC to the library', (
    WidgetTester tester,
  ) async {
    await pumpAndLoadAsyncContent(tester, const BookReaderApp());
    expect(find.text('المكتبة'), findsOneWidget);

    await tester.tap(find.byType(BookHeroCard).first);
    await tester.pumpAndSettle();
    expect(find.text('محتويات الكتاب'), findsOneWidget);
    expect(find.text('المكتبة'), findsNothing);

    // Regression check: the TOC app bar must not swallow the back button by
    // putting a custom widget in `leading` — Scaffold exposes the real
    // system back action here, not a stand-in icon.
    final backButton = find.byType(BackButton);
    expect(backButton, findsOneWidget);

    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(find.text('المكتبة'), findsOneWidget);
    expect(find.byType(BookHeroCard), findsNWidgets(2));
  });
}
