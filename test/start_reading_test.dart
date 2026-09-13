import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('Tapping "ابدأ القراءة" opens the first chapter', (
    WidgetTester tester,
  ) async {
    await pumpAndLoadAsyncContent(tester, const BookReaderApp());

    await tester.tap(find.text('ابدأ القراءة'));
    await tester.pumpAndSettle();

    // Matches both the app bar title and a heading block inside the chapter.
    expect(find.text('مقدمة الكتاب'), findsWidgets);
    expect(find.text('ابدأ القراءة'), findsNothing);
  });
}
