import 'package:assisted_living/services/constants.dart';
import 'package:assisted_living/services/language/language_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

// holds current language state and notifies listeners on change
// also listens to system language changes
class LanguageState with ChangeNotifier {
  late Locale _currentLanguage;

  void Function(Locale) _callback = (locale) {};

  void setCallback(void Function(Locale) callback) {
    _callback = callback;
  }

  Future<void> getLanguageFromLocalStorage(
    SharedPreferences localStorage,
  ) async {
    final savedLang = localStorage.getString(Constants.language_key);
    if (savedLang != null) {
      _currentLanguage = Locale(savedLang);
      setLanguage(_currentLanguage.languageCode);
    }
  }

  // set up listener for system language changes
  // and get initial language from local storage
  // if not found, use system preference
  LanguageState.initiateState(localStorage) {
    ui.PlatformDispatcher.instance.onLocaleChanged = () {
      print(
        'System locale changed to ${ui.PlatformDispatcher.instance.locale}',
      );
      final prefs = localStorage;
      final savedLang = prefs.getString(Constants.language_key);
      if (savedLang != null) {
        _currentLanguage = Locale(savedLang);
        setLanguage(_currentLanguage.languageCode);
        return;
      }

      _currentLanguage = LanguageUtils.bestSupportedLanguage();
      setLanguage(_currentLanguage.languageCode, localStore: localStorage);
    };
    getLanguageFromLocalStorage(localStorage);
  }

  void setLanguage(String lang, {SharedPreferences? localStore}) {
    _currentLanguage = Locale(lang);
    _callback.call(_currentLanguage);
    if (localStore != null) {
      localStore.remove(Constants.language_key);
    }
    notifyListeners();
  }
}
