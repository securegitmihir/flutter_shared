part of 'package:assisted_living/theme/app_theme.dart';

class BorderTheme {
  static OutlineInputBorder _border(pallete, r) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: pallete.primary, width: r.space(3)),
      borderRadius: BorderRadius.circular(r.px(10)),
    );
  }
}
