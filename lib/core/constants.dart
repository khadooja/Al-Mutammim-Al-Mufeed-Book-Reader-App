/// App-wide non-visual constants (asset paths, spacing, radii).
library;

class AppConstants {
  AppConstants._();

  static const String booksAssetsBasePath = 'lib/assets_data/books';

  /// The books bundled with the app, in the order they're meant to be read
  /// (المدخل is the prerequisite, المتمم its sequel) — which is also the
  /// order the library screen lists them in. Adding a book means adding its
  /// id here plus its assets in pubspec.yaml.
  static const List<String> libraryBookIds = [
    'al_madkhal_ila_ilm_al_tajweed',
    'al_mutammim_al_mufeed',
  ];
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
