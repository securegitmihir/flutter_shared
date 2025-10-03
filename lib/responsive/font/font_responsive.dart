part of 'package:assisted_living/responsive/responsive.dart';

/// Scale a TextStyle's fontSize using your Responsive.font(),
/// without touching family/weight/letterSpacing/etc.
extension ResponsiveStyle on TextStyle {
  TextStyle r(BuildContext context) {
    final r = context.responsive;
    final base = fontSize ?? 14; // safe fallback
    return copyWith(fontSize: r.font(base));
  }
}

/// Token-to-responsive helpers for convenience.
/// These keep your Material tokens intact but bump only fontSize.
extension ResponsiveTextTheme on TextTheme {
  static const fontKohinoorBold = "KohinoorDevanagari-Bold";
  static const fontKohinoorLight = "KohinoorDevanagari-Light";
  static const fontKohinoorMedium = "KohinoorDevanagari-Medium";
  static const fontKohinoorRegular = "KohinoorDevanagari-Regular";
  static const fontKohinoorSemiBold = "KohinoorDevanagari-Semibold";

   TextStyle? rDisplayLarge(BuildContext c) => displayLarge?.copyWith(fontSize: 18, fontFamily: fontKohinoorRegular, fontWeight: FontWeight.w400).r(c);
   TextStyle? rDisplayMedium(BuildContext c) => displayMedium?.copyWith(fontSize: 18, fontFamily: fontKohinoorRegular, fontWeight: FontWeight.w400).r(c);
   TextStyle? rDisplaySmall(BuildContext c) => displaySmall?.copyWith(fontSize: 18, fontFamily: fontKohinoorRegular, fontWeight: FontWeight.w400).r(c);

   TextStyle? rHeadlineLarge(BuildContext c) => headlineLarge?.copyWith(fontSize: 25, fontFamily: fontKohinoorSemiBold, fontWeight: FontWeight.w600).r(c);
   TextStyle? rHeadlineMedium(BuildContext c) => headlineMedium?.copyWith(fontSize: 24, fontFamily: fontKohinoorSemiBold, fontWeight: FontWeight.w600).r(c);
   TextStyle? rHeadlineSmall(BuildContext c) => headlineSmall?.copyWith(fontSize: 23, fontFamily: fontKohinoorSemiBold, fontWeight: FontWeight.w600).r(c);

   TextStyle? rTitleLarge(BuildContext c) => titleLarge?.copyWith(fontSize: 25, fontFamily: fontKohinoorMedium, fontWeight: FontWeight.w500).r(c);
   TextStyle? rTitleMedium(BuildContext c) => titleMedium?.copyWith(fontSize: 24, fontFamily: fontKohinoorMedium, fontWeight: FontWeight.w500).r(c);
   TextStyle? rTitleSmall(BuildContext c) => titleSmall?.copyWith(fontSize: 22, fontFamily: fontKohinoorMedium, fontWeight: FontWeight.w500).r(c);

   TextStyle? rLabelLarge(BuildContext c) => labelLarge?.copyWith(fontSize: 21, fontFamily: fontKohinoorMedium, fontWeight: FontWeight.w500,).r(c);
   TextStyle? rLabelMedium(BuildContext c) => labelMedium?.copyWith(fontSize: 20, fontFamily: fontKohinoorMedium, fontWeight: FontWeight.w500).r(c);
   TextStyle? rLabelSmall(BuildContext c) => labelSmall?.copyWith(fontSize: 19, fontFamily: fontKohinoorMedium, fontWeight: FontWeight.w500).r(c);

   TextStyle? rBodyLarge(BuildContext c) => bodyLarge?.copyWith(fontSize: 17, fontFamily: fontKohinoorRegular, fontWeight: FontWeight.w400).r(c);
   TextStyle? rBodyMedium(BuildContext c) => bodyMedium?.copyWith(fontSize: 16, fontFamily: fontKohinoorRegular, fontWeight: FontWeight.w400).r(c);
   TextStyle? rBodySmall(BuildContext c) => bodySmall?.copyWith(fontSize: 15, fontFamily: fontKohinoorRegular, fontWeight: FontWeight.w400).r(c);

  TextStyle? rError(BuildContext c) => bodyLarge?.copyWith(fontSize: 12, fontFamily: fontKohinoorRegular, fontWeight: FontWeight.w400, color: Theme.of(c).colorScheme.error,).r(c);
  TextStyle? rBtn(BuildContext c) => bodyLarge?.copyWith(fontSize: 24, fontFamily: fontKohinoorRegular, fontWeight: FontWeight.w400).r(c);
  TextStyle? rHint(BuildContext c) => bodyLarge?.copyWith(fontSize: 14, fontFamily: fontKohinoorRegular, fontWeight: FontWeight.w400).r(c);
}
