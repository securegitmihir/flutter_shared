part of '../app_theme.dart';

class ColorSchemeTheme {
  static ColorScheme _colorScheme(pallete, base) {
    return base.copyWith(
      primary: pallete.primary,
      primaryContainer: pallete.primaryVariant,
      secondary: pallete.secondary,
      secondaryContainer: pallete.secondaryVariant,
      surface: pallete.surface,
      error: pallete.error,
      onPrimary: pallete.onPrimary,
      onSecondary: pallete.onSecondary,
      onSurface: pallete.onSurface,
      onError: pallete.onError,
    );
  }
}
