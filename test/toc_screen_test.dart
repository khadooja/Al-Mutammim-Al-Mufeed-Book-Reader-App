import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:bookreader_app/models/book.dart';
import 'package:bookreader_app/models/chapter.dart';
import 'package:bookreader_app/screens/toc_screen.dart';

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
    id: 'b1',
    title: 'كتاب',
    author: 'مؤلف',
    description: 'وصف',
    chapters: const [
      Chapter(id: 'ch1', number: 1, title: 'الفصل الأول', icon: 'book', sections: []),
      Chapter(id: 'ch2', number: 2, title: 'الفصل الثاني', icon: 'waves', sections: []),
    ],
  );

  testWidgets('TocScreen lists all chapters without a hero card', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(TocScreen(book: book)));

    expect(find.text('محتويات الكتاب'), findsOneWidget);
    expect(
      find.textContaining('الفصل الأول', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('الفصل الثاني', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('ابدأ القراءة'), findsNothing);
  });

  testWidgets('TocScreen shows a message when the book has no chapters', (
    WidgetTester tester,
  ) async {
    final empty = Book(
      id: 'b2',
      title: 'كتاب فارغ',
      author: 'مؤلف',
      description: 'وصف',
      chapters: const [],
    );

    await tester.pumpWidget(_wrap(TocScreen(book: empty)));

    expect(find.text('لا توجد فصول متاحة حتى الآن.'), findsOneWidget);
  });
}
