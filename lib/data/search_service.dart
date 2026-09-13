import '../models/book.dart';
import '../models/chapter.dart';
import '../models/content_block.dart';

/// One matching content block: which chapter it's in, where in that
/// chapter's flattened block sequence it sits (so the reader screen can
/// scroll straight to it), and a short snippet around the match.
class SearchHit {
  final Chapter chapter;
  final int blockIndex;
  final String snippet;

  const SearchHit({
    required this.chapter,
    required this.blockIndex,
    required this.snippet,
  });
}

const int _snippetRadius = 40;

/// In-memory substring search over a book's already-loaded content — no
/// index, no async work, the whole book comfortably fits in memory.
class SearchService {
  const SearchService();

  List<SearchHit> search(Book book, String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final hits = <SearchHit>[];
    for (final chapter in book.chapters) {
      var blockIndex = 0;
      for (final section in chapter.sections) {
        for (final block in section.blocks) {
          final text = _textOf(block);
          if (text != null && text.contains(trimmed)) {
            hits.add(
              SearchHit(
                chapter: chapter,
                blockIndex: blockIndex,
                snippet: _snippet(text, trimmed),
              ),
            );
          }
          blockIndex++;
        }
      }
    }
    return hits;
  }

  String? _textOf(ContentBlock block) {
    return switch (block) {
      HeadingBlock() => block.text,
      TextBlock() => block.text,
      ImageBlock() => block.caption,
    };
  }

  String _snippet(String text, String query) {
    final matchIndex = text.indexOf(query);
    final start = (matchIndex - _snippetRadius).clamp(0, text.length);
    final end = (matchIndex + query.length + _snippetRadius).clamp(
      0,
      text.length,
    );

    final buffer = StringBuffer();
    if (start > 0) buffer.write('… ');
    buffer.write(text.substring(start, end));
    if (end < text.length) buffer.write(' …');
    return buffer.toString();
  }
}
