import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme/app_theme.dart';
import '../models/book.dart';
import '../widgets/chapter_tile.dart';
import 'chapter_screen.dart';
import 'search_screen.dart';

/// Standalone table-of-contents page — the same chapter-list design as the
/// home screen, without the hero card.
class TocScreen extends StatelessWidget {
  final Book book;

  const TocScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SearchScreen(book: book)),
            );
          },
        ),
        title: Text(book.title),
        actions: const [SizedBox(width: 48)],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'محتويات الكتاب',
                  style: AppTextStyles.tocHeading,
                ),
                const Icon(Icons.menu, color: AppColors.gold),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (book.chapters.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Text(
                  'لا توجد فصول متاحة حتى الآن.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption,
                ),
              )
            else
              for (final chapter in book.chapters) ...[
                ChapterTile(
                  chapter: chapter,
                  onTap: () => ChapterScreen.open(context, book, chapter),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
          ],
        ),
      ),
    );
  }
}
