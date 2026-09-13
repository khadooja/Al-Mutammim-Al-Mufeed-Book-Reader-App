import 'package:flutter/material.dart';

/// Maps a chapter/book `icon` key from book.json to a concrete [IconData].
/// Centralized here so chapter_tile.dart and book_card.dart stay in sync and
/// unknown keys degrade to a sensible default instead of crashing.
IconData iconForKey(String key) {
  switch (key) {
    case 'book':
      return Icons.menu_book_outlined;
    case 'waves':
      return Icons.graphic_eq_outlined;
    case 'quran':
    case 'reading':
      return Icons.import_contacts_outlined;
    case 'mouth':
    case 'articulation':
      return Icons.record_voice_over_outlined;
    case 'chart':
      return Icons.bar_chart_outlined;
    case 'circle':
      return Icons.circle_outlined;
    case 'letter':
      return Icons.text_fields_outlined;
    case 'warning':
      return Icons.warning_amber_outlined;
    default:
      return Icons.menu_book_outlined;
  }
}
