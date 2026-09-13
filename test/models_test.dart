import 'package:flutter_test/flutter_test.dart';
import 'package:bookreader_app/models/book.dart';
import 'package:bookreader_app/models/content_block.dart';

void main() {
  group('Book.fromJson', () {
    test('parses a well-formed book with nested chapters/sections/blocks', () {
      final book = Book.fromJson({
        'id': 'b1',
        'title': 'كتاب',
        'author': 'مؤلف',
        'description': 'وصف',
        'chapters': [
          {
            'id': 'ch1',
            'number': 1,
            'title': 'الفصل الأول',
            'icon': 'book',
            'sections': [
              {
                'blocks': [
                  {'type': 'heading', 'text': 'عنوان'},
                  {'type': 'text', 'text': 'نص'},
                  {'type': 'image', 'path': 'images/a.png', 'caption': 'شرح'},
                ],
              },
            ],
          },
        ],
      });

      expect(book.id, 'b1');
      expect(book.chapters, hasLength(1));

      final chapter = book.chapters.single;
      expect(chapter.number, 1);
      expect(chapter.sections, hasLength(1));

      final blocks = chapter.sections.single.blocks;
      expect(blocks, hasLength(3));
      expect((blocks[0] as HeadingBlock).text, 'عنوان');
      expect((blocks[1] as TextBlock).text, 'نص');
      expect((blocks[2] as ImageBlock).assetPath, 'images/a.png');
      expect((blocks[2] as ImageBlock).caption, 'شرح');
    });

    test('defaults chapters to an empty list when missing', () {
      final book = Book.fromJson({
        'id': 'b1',
        'title': 'كتاب',
        'author': 'مؤلف',
        'description': 'وصف',
      });

      expect(book.chapters, isEmpty);
    });

    test('throws FormatException when a required book field is missing', () {
      expect(
        () => Book.fromJson({'id': 'b1', 'title': 'كتاب'}),
        throwsFormatException,
      );
    });

    test('throws FormatException for an unknown content block type', () {
      expect(
        () => ContentBlock.fromJson({'type': 'video', 'text': 'x'}),
        throwsFormatException,
      );
    });
  });
}
