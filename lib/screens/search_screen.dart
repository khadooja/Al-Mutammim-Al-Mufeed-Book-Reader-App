import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme/app_theme.dart';
import '../data/search_service.dart';
import '../models/book.dart';
import 'chapter_screen.dart';

/// Search field + results list. Filtering runs synchronously on every
/// keystroke — no debounce needed since the whole book is already in
/// memory and a substring scan over it is effectively instant.
class SearchScreen extends StatefulWidget {
  final Book book;

  const SearchScreen({super.key, required this.book});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchService _searchService = const SearchService();
  final TextEditingController _controller = TextEditingController();
  List<SearchHit> _results = const [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {
      _results = _searchService.search(widget.book, query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onQueryChanged,
          textDirection: TextDirection.rtl,
          style: AppTextStyles.tileText,
          decoration: const InputDecoration(
            hintText: 'ابحث في الكتاب...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_controller.text.trim().isEmpty) {
      return const _SearchMessage(text: 'اكتب كلمة للبحث في محتوى الكتاب.');
    }
    if (_results.isEmpty) {
      return const _SearchMessage(text: 'لا توجد نتائج مطابقة.');
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final hit = _results[index];
        return _SearchResultTile(
          hit: hit,
          onTap: () => ChapterScreen.open(
            context,
            widget.book,
            hit.chapter,
            highlightBlockIndex: hit.blockIndex,
          ),
        );
      },
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final SearchHit hit;
  final VoidCallback onTap;

  const _SearchResultTile({required this.hit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${hit.chapter.number}. ${hit.chapter.title}',
              style: AppTextStyles.tileNumber,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(hit.snippet, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _SearchMessage extends StatelessWidget {
  final String text;

  const _SearchMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
        ),
      ),
    );
  }
}
