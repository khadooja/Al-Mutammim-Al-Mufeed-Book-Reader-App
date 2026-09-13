/// A single piece of chapter content, rendered in sequence by
/// `content_renderer.dart`. Polymorphic over [HeadingBlock], [TextBlock] and
/// [ImageBlock] — new block types must not be special-cased outside of
/// `content_renderer.dart`.
sealed class ContentBlock {
  const ContentBlock();

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    switch (type) {
      case 'heading':
        return HeadingBlock.fromJson(json);
      case 'text':
        return TextBlock.fromJson(json);
      case 'image':
        return ImageBlock.fromJson(json);
      default:
        throw FormatException(
          'Unknown content block type "$type" in book.json',
        );
    }
  }
}

class HeadingBlock extends ContentBlock {
  final String text;

  /// Heading level (1 = top-level). Defaults to 2 (sub-heading), matching
  /// the mockup's in-chapter heading style.
  final int level;

  const HeadingBlock({required this.text, this.level = 2});

  factory HeadingBlock.fromJson(Map<String, dynamic> json) {
    final text = json['text'] as String?;
    if (text == null) {
      throw const FormatException('Heading block is missing "text"');
    }
    return HeadingBlock(text: text, level: (json['level'] as num?)?.toInt() ?? 2);
  }
}

class TextBlock extends ContentBlock {
  final String text;

  const TextBlock({required this.text});

  factory TextBlock.fromJson(Map<String, dynamic> json) {
    final text = json['text'] as String?;
    if (text == null) {
      throw const FormatException('Text block is missing "text"');
    }
    return TextBlock(text: text);
  }
}

class ImageBlock extends ContentBlock {
  /// Path to the image asset, relative to the book's folder
  /// (e.g. "images/ch1_1.png").
  final String assetPath;
  final String? caption;

  const ImageBlock({required this.assetPath, this.caption});

  factory ImageBlock.fromJson(Map<String, dynamic> json) {
    final path = json['path'] as String?;
    if (path == null) {
      throw const FormatException('Image block is missing "path"');
    }
    return ImageBlock(assetPath: path, caption: json['caption'] as String?);
  }
}
