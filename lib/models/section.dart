import 'content_block.dart';

/// A block of related content within a [Chapter]. Most chapters have a
/// single unnamed section; [title] is only set when a chapter is split into
/// named sub-parts.
class Section {
  final String? id;
  final String? title;
  final List<ContentBlock> blocks;

  const Section({this.id, this.title, required this.blocks});

  factory Section.fromJson(Map<String, dynamic> json) {
    final rawBlocks = json['blocks'] as List<dynamic>? ?? const [];
    return Section(
      id: json['id'] as String?,
      title: json['title'] as String?,
      blocks: rawBlocks
          .map((b) => ContentBlock.fromJson(b as Map<String, dynamic>))
          .toList(),
    );
  }
}
