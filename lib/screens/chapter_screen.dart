import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme/app_theme.dart';
import '../models/book.dart';
import '../models/chapter.dart';
import '../widgets/content_renderer.dart';

/// Renders one chapter's content in reading order, with selectable text
/// and inline images.
class ChapterScreen extends StatefulWidget {
  final Book book;
  final Chapter chapter;

  /// When set (arriving from a search result), the reader scrolls this
  /// block — index into the chapter's flattened block sequence, matching
  /// SearchHit.blockIndex — into view after the first frame.
  final int? highlightBlockIndex;

  const ChapterScreen({
    super.key,
    required this.book,
    required this.chapter,
    this.highlightBlockIndex,
  });

  /// Pushes the reader screen for [chapter] — shared by the home, TOC, and
  /// search screens so all three navigate to a chapter the same way.
  static void open(
    BuildContext context,
    Book book,
    Chapter chapter, {
    int? highlightBlockIndex,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChapterScreen(
          book: book,
          chapter: chapter,
          highlightBlockIndex: highlightBlockIndex,
        ),
      ),
    );
  }

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  late final List<GlobalKey> _blockKeys;

  @override
  void initState() {
    super.initState();
    final blockCount = widget.chapter.sections.fold<int>(
      0,
      (total, section) => total + section.blocks.length,
    );
    _blockKeys = List.generate(blockCount, (_) => GlobalKey());

    final target = widget.highlightBlockIndex;
    if (target != null && target >= 0 && target < _blockKeys.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = _blockKeys[target].currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.1,
            duration: const Duration(milliseconds: 300),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapter.title, overflow: TextOverflow.ellipsis),
      ),
      body: SafeArea(
        child: widget.chapter.sections.isEmpty
            ? const _EmptyChapterState()
            : SelectionArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: ContentRenderer(
                    sections: widget.chapter.sections,
                    bookId: widget.book.id,
                    blockKeys: _blockKeys,
                  ),
                ),
              ),
      ),
    );
  }
}

class _EmptyChapterState extends StatelessWidget {
  const _EmptyChapterState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Text(
          'لا يوجد محتوى لهذا الفصل حتى الآن.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
        ),
      ),
    );
  }
}
