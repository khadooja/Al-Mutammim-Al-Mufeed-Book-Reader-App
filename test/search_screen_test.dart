import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:bookreader_app/models/book.dart';
import 'package:bookreader_app/models/chapter.dart';
import 'package:bookreader_app/models/section.dart';
import 'package:bookreader_app/models/content_block.dart';
import 'package:bookreader_app/screens/search_screen.dart';

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
      Chapter(
        id: 'ch1',
        number: 1,
        title: 'الفصل الأول',
        icon: 'book',
        sections: [
          Section(blocks: [TextBlock(text: 'نص عن مخارج الحروف.')]),
        ],
      ),
    ],
  );

  testWidgets('shows a prompt before typing and results while typing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(SearchScreen(book: book)));

    expect(find.text('اكتب كلمة للبحث في محتوى الكتاب.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'مخارج');
    await tester.pump();

    expect(find.textContaining('الفصل الأول', findRichText: true), findsOneWidget);
    expect(find.textContaining('مخارج', findRichText: true), findsWidgets);
  });

  testWidgets('shows a no-results message for a non-matching query', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(SearchScreen(book: book)));

    await tester.enterText(find.byType(TextField), 'كلمة غير موجودة');
    await tester.pump();

    expect(find.text('لا توجد نتائج مطابقة.'), findsOneWidget);
  });
}
