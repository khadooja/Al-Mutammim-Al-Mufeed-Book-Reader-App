import 'chapter.dart';

/// The book, loaded once from `book.json` by `books_repository.dart`.
class Book {
  final String id;
  final String title;
  final String? subtitle;
  final String author;
  final String description;

  /// Icon key for the home screen's hero card. Defaults to "book".
  final String coverIcon;
  final List<Chapter> chapters;

  const Book({
    required this.id,
    required this.title,
    this.subtitle,
    required this.author,
    required this.description,
    this.coverIcon = 'book',
    required this.chapters,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final title = json['title'] as String?;
    final author = json['author'] as String?;
    final description = json['description'] as String?;
    if (id == null || title == null || author == null || description == null) {
      throw const FormatException(
        'book.json is missing one of: "id", "title", "author", "description"',
      );
    }
    final rawChapters = json['chapters'] as List<dynamic>? ?? const [];
    return Book(
      id: id,
      title: title,
      subtitle: json['subtitle'] as String?,
      author: author,
      description: description,
      coverIcon: json['coverIcon'] as String? ?? 'book',
      chapters: rawChapters
          .map((c) => Chapter.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
