import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/app.dart';

void main() {
  testWidgets('App builds and shows the app bar title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BookReaderApp());
    await tester.pumpAndSettle();

    expect(find.text('المتمم المفيد'), findsOneWidget);
    expect(find.byType(Directionality), findsWidgets);
  });
}
