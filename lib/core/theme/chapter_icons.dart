import 'package:flutter/material.dart';

/// Maps a chapter/book `icon` key from book.json to a concrete [IconData],
/// matching the per-chapter icon set drawn in ui_mockup.html. Centralized
/// here so chapter_tile.dart and book_card.dart stay in sync and unknown
/// keys degrade to a sensible default instead of crashing.
IconData iconForKey(String key) {
  switch (key) {
    case 'book':
      return Icons.menu_book_outlined;
    case 'graduation_cap':
      return Icons.school_outlined;
    case 'open_book':
      return Icons.auto_stories_outlined;
    case 'mouth':
    case 'articulation':
      return Icons.record_voice_over_outlined;
    case 'waveform':
    case 'waves':
      return Icons.graphic_eq_outlined;
    case 'contrast':
      return Icons.contrast;
    case 'text_tt':
    case 'letter':
      return Icons.text_fields_outlined;
    case 'warning':
      return Icons.warning_amber_outlined;
    case 'merge':
      return Icons.call_merge_outlined;
    case 'stop_circle':
      return Icons.stop_circle_outlined;
    case 'pause':
      return Icons.pause_circle_outline;
    default:
      return Icons.menu_book_outlined;
  }
}
