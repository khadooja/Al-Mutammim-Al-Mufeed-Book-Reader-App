import 'section.dart';

/// One chapter of the book, shown as a tile on the home/TOC screens and
/// rendered in full on the chapter/reader screen.
class Chapter {
  final String id;
  final int number;
  final String title;

  /// Icon key (e.g. "book", "waves") looked up against an icon map in the
  /// widgets layer — models stay presentation-agnostic.
  final String icon;
  final List<Section> sections;

  const Chapter({
    required this.id,
    required this.number,
    required this.title,
    required this.icon,
    required this.sections,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final title = json['title'] as String?;
    if (id == null || title == null) {
      throw const FormatException('Chapter is missing "id" or "title"');
    }
    final rawSections = json['sections'] as List<dynamic>? ?? const [];
    return Chapter(
      id: id,
      number: (json['number'] as num?)?.toInt() ?? 0,
      title: title,
      icon: json['icon'] as String? ?? 'book',
      sections: rawSections
          .map((s) => Section.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}
