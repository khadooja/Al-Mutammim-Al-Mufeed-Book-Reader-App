import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/chapter_icons.dart';
import '../models/chapter.dart';

/// A single chapter row: chevron, number + title, and a circular icon —
/// used on both the home screen's chapter list and the standalone TOC
/// screen so the two stay visually identical.
class ChapterTile extends StatelessWidget {
  final Chapter chapter;
  final VoidCallback? onTap;

  const ChapterTile({super.key, required this.chapter, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        child: Row(
          children: [
            const Icon(Icons.chevron_left, size: 14, color: AppColors.gold),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.tileText,
                  children: [
                    TextSpan(
                      text: '${chapter.number}. ',
                      style: AppTextStyles.tileNumber,
                    ),
                    TextSpan(text: chapter.title),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.sageSoft,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.goldSoft, width: 1.5),
              ),
              child: Icon(
                iconForKey(chapter.icon),
                size: 17,
                color: AppColors.forest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
