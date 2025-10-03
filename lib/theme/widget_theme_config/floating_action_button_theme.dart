part of 'package:assisted_living/theme/app_theme.dart';

class FloatingActionButtonTheme {
  static FloatingActionButtonThemeData _floatingActionButtonTheme(
    ColorPallete pallete,
    Responsive r,
  ) {
    return FloatingActionButtonThemeData(
      backgroundColor: pallete.primary,
      foregroundColor: pallete.onPrimary,
      focusElevation: r.px(4),
      focusColor: pallete.primaryVariant,
      hoverColor: pallete.primaryVariant,
      hoverElevation: r.px(6),
      iconSize: r.px(26),
      extendedPadding: EdgeInsets.all(r.space(22)),
    );
  }
}
