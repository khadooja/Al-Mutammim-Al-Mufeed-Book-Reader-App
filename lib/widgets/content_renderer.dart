import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme/app_theme.dart';
import '../models/content_block.dart';
import '../models/section.dart';
import 'selectable_text_block.dart';

/// Renders a chapter's sections/blocks in sequence — sub-headings,
/// selectable paragraphs, and inline images — in their original document
/// order. New [ContentBlock] types must be handled here, and only here.
class ContentRenderer extends StatelessWidget {
  final List<Section> sections;
  final String bookId;

  const ContentRenderer({
    super.key,
    required this.sections,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final section in sections) ...[
          if (section.title != null) ...[
            Text(section.title!, style: AppTextStyles.contentHeading),
            const SizedBox(height: AppSpacing.md),
          ],
          for (final block in section.blocks) ...[
            _buildBlock(block),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ],
    );
  }

  Widget _buildBlock(ContentBlock block) {
    return switch (block) {
      HeadingBlock() => Text(block.text, style: AppTextStyles.contentHeading),
      TextBlock() => SelectableTextBlock(text: block.text),
      ImageBlock() => _ChapterImage(block: block, bookId: bookId),
    };
  }
}

class _ChapterImage extends StatelessWidget {
  final ImageBlock block;
  final String bookId;

  const _ChapterImage({required this.block, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final fullPath =
        '${AppConstants.booksAssetsBasePath}/$bookId/${block.assetPath}';

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.card),
          child: Image.asset(
            fullPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const _MissingImagePlaceholder(),
          ),
        ),
        if (block.caption != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            block.caption!,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ],
    );
  }
}

class _MissingImagePlaceholder extends StatelessWidget {
  const _MissingImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxl,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.sageSoft,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.line),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.inkMuted,
            size: 32,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'الصورة غير متوفرة بعد',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
