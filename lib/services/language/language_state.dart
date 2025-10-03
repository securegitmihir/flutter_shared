import 'package:flutter/material.dart';

class LanguageState with ChangeNotifier {
  Locale currentLanguage = const Locale('en');

  get locale => currentLanguage;

  void setLanguage(String lang) {
    currentLanguage = Locale(lang);
    notifyListeners();
  }
}
