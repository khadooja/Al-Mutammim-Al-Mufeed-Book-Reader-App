import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:bookreader_app/models/book.dart';
import 'package:bookreader_app/models/chapter.dart';
import 'package:bookreader_app/models/section.dart';
import 'package:bookreader_app/models/content_block.dart';
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

void main() {
  final book = Book(
    id: 'al_mutammim_al_mufeed',
    title: 'كتاب',
    author: 'مؤلف',
    description: 'وصف',
    chapters: const [],
  );

  testWidgets('renders headings, paragraphs and a missing-image placeholder in order', (
    WidgetTester tester,
  ) async {
    final chapter = Chapter(
      id: 'ch1',
      number: 1,
      title: 'الفصل الأول',
      icon: 'book',
      sections: const [
        Section(
          blocks: [
            HeadingBlock(text: 'عنوان الفصل'),
            TextBlock(text: 'هذه فقرة نصية قابلة للتحديد.'),
            ImageBlock(
              assetPath: 'images/does_not_exist.png',
              caption: 'توضيح',
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      _wrap(ChapterScreen(book: book, chapter: chapter)),
    );
    await tester.pumpAndSettle();

    expect(find.text('عنوان الفصل'), findsOneWidget);
    expect(find.text('هذه فقرة نصية قابلة للتحديد.'), findsOneWidget);
    // The referenced image asset doesn't exist, so the fallback placeholder
    // (not a broken-image icon or blank screen) must show instead.
    expect(find.text('الصورة غير متوفرة بعد'), findsOneWidget);
    expect(find.text('توضيح'), findsOneWidget);
  });

  testWidgets('shows an empty-state message when a chapter has no sections', (
    WidgetTester tester,
  ) async {
    final chapter = Chapter(
      id: 'ch2',
      number: 2,
      title: 'فصل فارغ',
      icon: 'book',
      sections: const [],
    );

    await tester.pumpWidget(
      _wrap(ChapterScreen(book: book, chapter: chapter)),
    );
    await tester.pumpAndSettle();

    expect(find.text('لا يوجد محتوى لهذا الفصل حتى الآن.'), findsOneWidget);
  });
}
