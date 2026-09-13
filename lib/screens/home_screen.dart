import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme/app_theme.dart';
import '../data/books_repository.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import '../widgets/chapter_tile.dart';
import 'chapter_screen.dart';
import 'search_screen.dart';
import 'toc_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BooksRepository _repository = const BooksRepository();
  late final Future<Book> _bookFuture;

  @override
  void initState() {
    super.initState();
    _bookFuture = _repository.loadBook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            final book = await _bookFuture;
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SearchScreen(book: book)),
            );
          },
        ),
        title: const Text('المتمم المفيد'),
        actions: const [SizedBox(width: 48)],
      ),
      body: FutureBuilder<Book>(
        future: _bookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorState(error: snapshot.error!);
          }

          final book = snapshot.data!;
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              children: [
                BookHeroCard(
                  book: book,
                  onStartReading: book.chapters.isEmpty
                      ? null
                      : () => ChapterScreen.open(
                          context,
                          book,
                          book.chapters.first,
                        ),
                ),
                const SizedBox(height: AppSpacing.xl + 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'محتويات الكتاب',
                      style: AppTextStyles.sectionHeading,
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu, color: AppColors.gold),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TocScreen(book: book),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (book.chapters.isEmpty)
                  const _EmptyChaptersState()
                else
                  Column(
                    children: [
                      for (final chapter in book.chapters) ...[
                        ChapterTile(
                          chapter: chapter,
                          onTap: () =>
                              ChapterScreen.open(context, book, chapter),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Object error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    final message = error is BookLoadException
        ? (error as BookLoadException).message
        : 'حدث خطأ غير متوقع أثناء تحميل الكتاب.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 40,
              color: AppColors.inkMuted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'تعذّر تحميل الكتاب',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionHeading,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChaptersState extends StatelessWidget {
  const _EmptyChaptersState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Text(
        'لا توجد فصول متاحة حتى الآن.',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption,
      ),
    );
  }
}
