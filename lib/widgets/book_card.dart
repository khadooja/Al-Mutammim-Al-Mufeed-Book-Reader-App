import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/chapter_icons.dart';
import '../models/book.dart';

/// The home screen's hero card: cover icon, title/subtitle/author,
/// description, and the "start reading" call to action.
class BookHeroCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onStartReading;

  const BookHeroCard({super.key, required this.book, this.onStartReading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xl,
        AppSpacing.xxl - 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.sage,
        borderRadius: BorderRadius.circular(AppRadii.hero),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.forest,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: Icon(
              iconForKey(book.coverIcon),
              size: 26,
              color: AppColors.ivory,
            ),
          ),
          const SizedBox(height: AppSpacing.md + 2),
          Text(
            book.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.heroHeading,
          ),
          if (book.subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs + 2),
            Text(
              book.subtitle!,
              textAlign: TextAlign.center,
              style: AppTextStyles.heroSubtitle,
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Text(
            book.author,
            textAlign: TextAlign.center,
            style: AppTextStyles.heroAuthor,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            book.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.heroDescription,
          ),
          const SizedBox(height: AppSpacing.lg + 2),
          ElevatedButton.icon(
            onPressed: onStartReading,
            icon: const Icon(Icons.play_arrow),
            label: const Text('ابدأ القراءة'),
          ),
        ],
      ),
    );
  }
}
