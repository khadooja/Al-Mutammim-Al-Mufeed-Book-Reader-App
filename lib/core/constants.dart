/// App-wide non-visual constants (asset paths, spacing, radii).
library;

class AppConstants {
  AppConstants._();

  static const String booksAssetsBasePath = 'lib/assets_data/books';
  static const String defaultBookId = 'al_mutammim_al_mufeed';
  static const String defaultBookJsonPath =
      '$booksAssetsBasePath/$defaultBookId/book.json';
}

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 22;
  static const double xxl = 28;
}

class AppRadii {
  AppRadii._();

  static const double card = 16;
  static const double hero = 22;
  static const double pill = 999;
}
