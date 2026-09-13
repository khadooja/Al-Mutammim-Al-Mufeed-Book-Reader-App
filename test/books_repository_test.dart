import 'package:flutter_test/flutter_test.dart';
import 'package:bookreader_app/core/constants.dart';
import 'package:bookreader_app/data/books_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BooksRepository', () {
    const repository = BooksRepository();

    test('loads and parses a bundled book by id', () async {
      final book = await repository.loadBook('al_mutammim_al_mufeed');

      expect(book.id, 'al_mutammim_al_mufeed');
      expect(book.title, 'المتمم المفيد');
      expect(book.chapters, isNotEmpty);
      expect(book.chapters.first.sections, isNotEmpty);
    });

    test('throws BookLoadException for an unknown book id', () async {
      expect(
        () => repository.loadBook('does_not_exist'),
        throwsA(isA<BookLoadException>()),
      );
    });

    test('loadLibrary loads every configured book, in order', () async {
      final books = await repository.loadLibrary();

      expect(books, hasLength(AppConstants.libraryBookIds.length));
      expect(
        books.map((b) => b.id).toList(),
        AppConstants.libraryBookIds,
      );
      for (final book in books) {
        expect(book.chapters, isNotEmpty);
      }
    });
  });
}
