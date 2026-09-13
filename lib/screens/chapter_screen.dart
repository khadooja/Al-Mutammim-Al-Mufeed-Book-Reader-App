import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme/app_theme.dart';
import '../models/book.dart';
import '../models/chapter.dart';
import '../widgets/content_renderer.dart';

/// Renders one chapter's content in reading order, with selectable text
/// and inline images.
class ChapterScreen extends StatelessWidget {
  final Book book;
  final Chapter chapter;

  const ChapterScreen({super.key, required this.book, required this.chapter});

  /// Pushes the reader screen for [chapter] — shared by the home and TOC
  /// screens so both navigate to a chapter the same way.
  static void open(BuildContext context, Book book, Chapter chapter) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChapterScreen(book: book, chapter: chapter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.title, overflow: TextOverflow.ellipsis),
      ),
      body: SafeArea(
        child: chapter.sections.isEmpty
            ? const _EmptyChapterState()
            : SelectionArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: ContentRenderer(
                    sections: chapter.sections,
                    bookId: book.id,
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
