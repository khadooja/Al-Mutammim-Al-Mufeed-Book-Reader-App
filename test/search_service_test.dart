import 'package:flutter_test/flutter_test.dart';

import 'package:bookreader_app/data/search_service.dart';
import 'package:bookreader_app/models/book.dart';
import 'package:bookreader_app/models/chapter.dart';
import 'package:bookreader_app/models/section.dart';
import 'package:bookreader_app/models/content_block.dart';

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
          Section(
            blocks: [
              HeadingBlock(text: 'عنوان الفصل'),
              TextBlock(text: 'هذا نص يتحدث عن أحكام التجويد بالتفصيل.'),
              ImageBlock(assetPath: 'images/a.png', caption: 'صورة توضيحية'),
            ],
          ),
        ],
      ),
      Chapter(
        id: 'ch2',
        number: 2,
        title: 'الفصل الثاني',
        icon: 'book',
        sections: [
          Section(blocks: [TextBlock(text: 'فقرة لا علاقة لها بالبحث.')]),
        ],
      ),
    ],
  );

  const service = SearchService();

  test('returns no results for an empty or whitespace query', () {
    expect(service.search(book, ''), isEmpty);
    expect(service.search(book, '   '), isEmpty);
  });

  test('finds matches in heading, text and image caption blocks', () {
    final results = service.search(book, 'أحكام');
    expect(results, hasLength(1));
    expect(results.single.chapter.id, 'ch1');
    expect(results.single.blockIndex, 1);
  });

  test('matches image captions', () {
    final results = service.search(book, 'توضيحية');
    expect(results, hasLength(1));
    expect(results.single.blockIndex, 2);
  });

  test('does not match text in other chapters', () {
    final results = service.search(book, 'التجويد');
    expect(results, hasLength(1));
    expect(results.single.chapter.id, 'ch1');
  });

  test('snippet is truncated with an ellipsis for long surrounding text', () {
    final results = service.search(book, 'أحكام');
    expect(results.single.snippet, contains('أحكام'));
  });
}
