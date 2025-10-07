import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:assisted_living/services/constants.dart';

/// finds the best matching language from the supported language list
/// based on the device preferred language.
class LanguageUtils {
  static Locale bestSupportedLanguage() {
    final supported = Constants.supportedLanguages
        .map((c) => Locale(c.code))
        .toList();
    final defaultLocale = Locale(Constants.defaultLanguage);

    final prefs = PlatformDispatcher.instance.locales.isNotEmpty
        ? PlatformDispatcher.instance.locales
        : [PlatformDispatcher.instance.locale ?? defaultLocale];

    // exact match
    for (final p in prefs) {
      for (final s in supported) {
        if (s.languageCode == p.languageCode &&
            (s.countryCode ?? '') == (p.countryCode ?? '')) {
          return s;
        }
      }
    }
    // language-only
    for (final p in prefs) {
      for (final s in supported) {
        if (s.languageCode == p.languageCode) return s;
      }
    }
    return defaultLocale;
  }
}
