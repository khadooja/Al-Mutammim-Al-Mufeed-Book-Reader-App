import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:bookreader_app/data/books_repository.dart';
import 'package:bookreader_app/models/book.dart';
import 'package:bookreader_app/screens/chapter_screen.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    home: Directionality(textDirection: TextDirection.rtl, child: child),
  );
}

const String _missingImageMessage = 'الصورة غير متوفرة بعد';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Book book;

  setUpAll(() async {
    book = await const BooksRepository().loadBook('al_mutammim_al_mufeed');
  });

  testWidgets('a chapter\'s bundled image asset actually resolves', (
    WidgetTester tester,
  ) async {
    // Chapter 10 is small and carries one real image file.
    final chapter = book.chapters.firstWhere((c) => c.number == 10);

    await tester.pumpWidget(_wrap(ChapterScreen(book: book, chapter: chapter)));
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsWidgets);
    // If the asset path didn't resolve, errorBuilder would swap in the
    // missing-image placeholder instead.
    expect(find.text(_missingImageMessage), findsNothing);
  });

  testWidgets('an image with no bundled file still falls back gracefully', (
    WidgetTester tester,
  ) async {
    // Chapter 2 references img-011-002.jpg, which was not delivered with the
    // rest of the extracted images.
    final chapter = book.chapters.firstWhere((c) => c.number == 2);

    await tester.pumpWidget(_wrap(ChapterScreen(book: book, chapter: chapter)));
    await tester.pumpAndSettle();

    expect(find.text(_missingImageMessage), findsOneWidget);
  });
}
