import 'package:assisted_living/app/routes/app_routes.dart';
import 'package:flutter/material.dart';

class Constants {
  static const apiTimeout = 30;
  static const other = 'other';
  static const regExpEmailAddress =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const supportedLanguages = [
    (
      code: 'en',
      locale: Locale('en'),
      emoji: '🇺🇸',
      name: 'English',
      native: 'English',
    ),
    (
      code: 'hi',
      locale: Locale('hi'),
      emoji: '🇮🇳',
      name: 'Hindi',
      native: 'हिन्दी',
    ),
  ];
  static const defaultLanguage = 'en';
  static const languageKey = 'i18n_lang';
  static const restrictedRotationPaths = {AppRoutes.splash};
}
