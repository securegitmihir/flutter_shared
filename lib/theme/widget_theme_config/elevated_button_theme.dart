part of 'package:assisted_living/theme/app_theme.dart';

class ElevatedBtnTheme {
  static ElevatedButtonThemeData _elevatedButtonTheme(pallete, r) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: pallete.button,
        foregroundColor: pallete.onButton,
        padding: EdgeInsets.symmetric(
          vertical: r.space(20),
          horizontal: r.space(16),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r.px(12)),
        ),
      ),
    );
  }
}
