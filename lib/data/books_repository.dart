import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../core/constants.dart';
import '../models/book.dart';

/// Thrown when a book's bundled JSON asset is missing or malformed, so
/// callers can show a clear error instead of a blank screen.
class BookLoadException implements Exception {
  final String message;

  const BookLoadException(this.message);

  @override
  String toString() => 'BookLoadException: $message';
}

/// Reads book data from the bundled `assets_data/books/<id>/book.json`
/// assets — the only source of content in this fully-offline app.
class BooksRepository {
  const BooksRepository();

  String _assetPathFor(String bookId) =>
      '${AppConstants.booksAssetsBasePath}/$bookId/book.json';

  /// Loads and parses the book with [bookId] (defaults to the app's single
  /// bundled book).
  Future<Book> loadBook([String bookId = AppConstants.defaultBookId]) async {
    final path = _assetPathFor(bookId);

    final String raw;
    try {
      raw = await rootBundle.loadString(path);
    } catch (_) {
      throw BookLoadException('Could not find book data at "$path".');
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException catch (e) {
      throw BookLoadException(
        'book.json at "$path" is not valid JSON: ${e.message}',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw BookLoadException('book.json at "$path" must be a JSON object.');
    }

    try {
      return Book.fromJson(decoded);
    } on FormatException catch (e) {
      throw BookLoadException(
        'book.json at "$path" is malformed: ${e.message}',
      );
    }
  }
}
