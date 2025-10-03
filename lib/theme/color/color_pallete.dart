part of 'package:assisted_living/theme/app_theme.dart';

class ColorPallete {
  final Map<String, Color> _colors;

  ColorPallete._(this._colors);

  static final Map<ThemeType, ColorPallete> _cache = {};

  factory ColorPallete.getThemePallete(ThemeType theme) {
    if (_cache.containsKey(theme)) {
      return _cache[theme]!;
    } else {
      final colors = _getColorMap(theme);
      final instance = ColorPallete._(colors);
      _cache[theme] = instance;
      return instance;
    }
  }

  Color get(String colorName) => _colors[colorName] ?? Colors.transparent;

  Color get primary => get(ColorMaster.primary);
  Color get primaryVariant => get(ColorMaster.primaryVariant);
  Color get secondary => get(ColorMaster.secondary);
  Color get secondaryVariant => get(ColorMaster.secondaryVariant);
  Color get surface => get(ColorMaster.surface);
  Color get error => get(ColorMaster.error);
  Color get onPrimary => get(ColorMaster.onPrimary);
  Color get onSecondary => get(ColorMaster.onSecondary);
  Color get onSurface => get(ColorMaster.onSurface);
  Color get onError => get(ColorMaster.onError);
  Color get button => get(ColorMaster.button);
  Color get onButton => get(ColorMaster.onButton);

  static Map<String, Color> _getColorMap(ThemeType theme) {
    switch (theme) {
      case ThemeType.light:
        return _lightPalette;
      case ThemeType.dark:
        return _darkPalette;
    }
  }

  static final Map<String, Color> _lightPalette = {
    ColorMaster.primary: Color.fromARGB(255, 59, 121, 141),
    ColorMaster.primaryVariant: Color.fromARGB(255, 111, 127, 145),
    ColorMaster.secondary: Color.fromARGB(255, 89, 109, 121),
    ColorMaster.secondaryVariant: Color.fromARGB(255, 125, 155, 155),
    ColorMaster.surface: Color(0xFFFFFFFF),
    ColorMaster.error: Color(0xFFB00020),
    ColorMaster.onPrimary: Color(0xFFFFFFFF),
    ColorMaster.onSecondary: Color(0xFF000000),
    ColorMaster.onSurface: Color(0xFF000000),
    ColorMaster.onError: Color(0xFFFFFFFF),
    ColorMaster.button: Color.fromARGB(255, 91, 145, 167),
    ColorMaster.onButton: Color(0xFFFFFFFF),
  };

  static final Map<String, Color> _darkPalette = {
    ColorMaster.primary: Color.fromARGB(255, 59, 121, 141),
    ColorMaster.primaryVariant: Color.fromARGB(255, 111, 127, 145),
    ColorMaster.secondary: Color.fromARGB(255, 143, 174, 194),
    ColorMaster.secondaryVariant: Color.fromARGB(255, 125, 155, 155),
    ColorMaster.surface: Color(0xFF121212),
    ColorMaster.error: Color(0xFFCF6679),
    ColorMaster.onPrimary: Color(0xFF000000),
    ColorMaster.onSecondary: Color(0xFF000000),
    ColorMaster.onSurface: Color(0xFFFFFFFF),
    ColorMaster.onError: Color(0xFF000000),
    ColorMaster.button: Color.fromARGB(255, 91, 145, 167),
    ColorMaster.onButton: Color(0xFFFFFFFF),
  };
}
