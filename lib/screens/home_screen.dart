import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme/app_theme.dart';
import '../data/books_repository.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'toc_screen.dart';

/// The library: one card per bundled book. Tapping a book opens its own
/// table of contents, and the reader/search flow continues from there.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BooksRepository _repository = const BooksRepository();
  late final Future<List<Book>> _libraryFuture;

  @override
  void initState() {
    super.initState();
    _libraryFuture = _repository.loadLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المكتبة')),
      body: FutureBuilder<List<Book>>(
        future: _libraryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorState(error: snapshot.error!);
          }

          final books = snapshot.data!;
          if (books.isEmpty) {
            return const _EmptyLibraryState();
          }

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              children: [
                for (final book in books) ...[
                  BookHeroCard(
                    book: book,
                    onStartReading: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TocScreen(book: book)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
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
        : 'حدث خطأ غير متوقع أثناء تحميل الكتب.';

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
              'تعذّر تحميل الكتب',
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

class _EmptyLibraryState extends StatelessWidget {
  const _EmptyLibraryState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Text(
          'لا توجد كتب متاحة حتى الآن.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
        ),
      ),
    );
  }
}
