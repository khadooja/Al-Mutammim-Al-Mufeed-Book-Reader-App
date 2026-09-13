import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';
import 'package:bookreader_app/widgets/book_card.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Tapping a book card opens that book\'s TOC', (
    WidgetTester tester,
  ) async {
    await pumpAndLoadAsyncContent(tester, const BookReaderApp());

    // Second card is المتمم المفيد (the library lists المدخل first); it sits
    // below the fold at the test viewport size, so scroll it in first.
    final card = find.widgetWithText(BookHeroCard, 'المتمم المفيد');
    await tester.ensureVisible(card);
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.text('محتويات الكتاب'), findsOneWidget);
    expect(find.text('المتمم المفيد'), findsWidgets);
    expect(find.text('ابدأ القراءة'), findsNothing);
  });
}
