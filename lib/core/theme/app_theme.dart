import 'package:flutter/material.dart';

/// Design tokens from docs/ui_mockup.html — treat that file as the source of
/// truth for any future color/typography changes.
class AppColors {
  AppColors._();

  static const Color ink = Color(0xFF1F2A24);
  static const Color inkMuted = Color(0xFF5B6B62);
  static const Color forest = Color(0xFF1B4D3E);
  static const Color forestDeep = Color(0xFF123529);
  static const Color sage = Color(0xFFDCEFE1);
  static const Color sageSoft = Color(0xFFEEF7F1);
  static const Color ivory = Color(0xFFF7F4EC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color gold = Color(0xFFB8935B);
  static const Color goldSoft = Color(0xFFE9DDC6);
  static const Color line = Color(0xFFE3E0D3);
}

class AppTextStyles {
  AppTextStyles._();

  static const String amiri = 'Amiri';
  static const String tajawal = 'Tajawal';

  // Amiri (serif) — book title, headings, hero heading.
  static const TextStyle docTitle = TextStyle(
    fontFamily: amiri,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.forestDeep,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: amiri,
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: AppColors.forestDeep,
  );

  static const TextStyle heroHeading = TextStyle(
    fontFamily: amiri,
    fontSize: 23,
    fontWeight: FontWeight.w700,
    color: AppColors.forestDeep,
  );

  static const TextStyle sectionHeading = TextStyle(
    fontFamily: amiri,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.forestDeep,
  );

  static const TextStyle tocHeading = TextStyle(
    fontFamily: amiri,
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: AppColors.forestDeep,
  );

  // Tajawal (sans) — body / UI text.
  static const TextStyle heroSubtitle = TextStyle(
    fontFamily: tajawal,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.forest,
  );

  static const TextStyle heroAuthor = TextStyle(
    fontFamily: tajawal,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
  );

  static const TextStyle heroDescription = TextStyle(
    fontFamily: tajawal,
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    height: 1.9,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: tajawal,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.ivory,
  );

  static const TextStyle tileText = TextStyle(
    fontFamily: tajawal,
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    height: 1.5,
  );

  static const TextStyle tileNumber = TextStyle(
    fontFamily: tajawal,
    fontSize: 13.5,
    fontWeight: FontWeight.w700,
    color: AppColors.forest,
  );

  // Reader content styles.
  static const TextStyle contentHeading = TextStyle(
    fontFamily: amiri,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.forestDeep,
    height: 1.6,
  );

  static const TextStyle contentBody = TextStyle(
    fontFamily: tajawal,
    fontSize: 15.5,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    height: 2.0,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: tajawal,
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
    height: 1.8,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.tajawal,
      scaffoldBackgroundColor: AppColors.ivory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.forest,
        primary: AppColors.forest,
        secondary: AppColors.gold,
        surface: AppColors.card,
        brightness: Brightness.light,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.sageSoft,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.appBarTitle,
        iconTheme: IconThemeData(color: AppColors.forest),
        shape: Border(bottom: BorderSide(color: AppColors.line, width: 1)),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.line, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forestDeep,
          foregroundColor: AppColors.ivory,
          textStyle: AppTextStyles.buttonLabel,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.line, thickness: 1),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColors.sage,
        cursorColor: AppColors.forest,
        selectionHandleColor: AppColors.forest,
      ),
    );
  }
}
