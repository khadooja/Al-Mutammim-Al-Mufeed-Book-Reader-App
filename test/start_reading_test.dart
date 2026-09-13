import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('"ابدأ القراءة" opens that book\'s TOC, then a chapter opens '
      'the reader', (WidgetTester tester) async {
    await pumpAndLoadAsyncContent(tester, const BookReaderApp());

    // First card is المدخل إلى علم التجويد.
    await tester.tap(find.text('ابدأ القراءة').first);
    await tester.pumpAndSettle();

    expect(find.text('محتويات الكتاب'), findsOneWidget);
    expect(find.text('ابدأ القراءة'), findsNothing);

    // The TOC's first chapter tile opens the reader.
    await tester.tap(find.textContaining('1.', findRichText: true).first);
    await tester.pumpAndSettle();

    expect(find.text('محتويات الكتاب'), findsNothing);
  });
}
