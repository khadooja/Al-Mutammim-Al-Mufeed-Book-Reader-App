import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Renders a single paragraph of chapter body text. Selection (and the
/// system copy menu) comes from the ancestor `SelectionArea` in
/// chapter_screen.dart, which lets a reader select text across multiple
/// paragraphs/headings as one continuous range — Share is added to that
/// menu in milestone #8.
class SelectableTextBlock extends StatelessWidget {
  final String text;

  const SelectableTextBlock({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.contentBody,
      textAlign: TextAlign.justify,
    );
  }
}
