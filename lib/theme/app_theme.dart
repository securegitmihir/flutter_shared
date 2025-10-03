import 'package:flutter/material.dart';
import 'package:assisted_living/responsive/responsive.dart';

import '../services/shared_pref_service.dart';

part 'package:assisted_living/theme/theme_state.dart';

part 'color/color_pallete.dart';
part 'color/theme_type.dart';
part 'color/color_master.dart';

part 'widget_theme_config/color_scheme_theme.dart';
part 'widget_theme_config/border_theme.dart';
part 'widget_theme_config/elevated_button_theme.dart';
part 'widget_theme_config/floating_action_button_theme.dart';

class AppTheme {
  static ThemeData getTheme(ThemeType themeType, Responsive r) {
    switch (themeType) {
      case ThemeType.dark:
        return darkThemeMode(r);
      case ThemeType.light:
        return lightThemeMode(r);
    }
  }

  static ThemeData darkThemeMode(Responsive r) {
    final pallete = ColorPallete.getThemePallete(ThemeType.dark);
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      // textTheme: FontFamilyTheme._fontFamilyTheme(base.textTheme),
      colorScheme: ColorSchemeTheme._colorScheme(pallete, base.colorScheme),
      scaffoldBackgroundColor: pallete.surface,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(27),
        enabledBorder: BorderTheme._border(pallete, r),
        focusedBorder: BorderTheme._border(pallete, r),
      ),
      elevatedButtonTheme: ElevatedBtnTheme._elevatedButtonTheme(pallete, r),
      floatingActionButtonTheme:
          FloatingActionButtonTheme._floatingActionButtonTheme(pallete, r),
    );
  }

  static ThemeData lightThemeMode(Responsive r) {
    final pallete = ColorPallete.getThemePallete(ThemeType.light);
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      // textTheme: FontFamilyTheme._fontFamilyTheme(base.textTheme),
      colorScheme: ColorSchemeTheme._colorScheme(pallete, base.colorScheme),
      scaffoldBackgroundColor: pallete.surface,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(27),
        enabledBorder: BorderTheme._border(pallete, r),
        focusedBorder: BorderTheme._border(pallete, r),
      ),
      elevatedButtonTheme: ElevatedBtnTheme._elevatedButtonTheme(pallete, r),
      floatingActionButtonTheme:
          FloatingActionButtonTheme._floatingActionButtonTheme(pallete, r),
    );
  }
}
