import 'package:assisted_living/app/configuration/constants.dart';
import 'package:assisted_living/utilities/language/language_utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../services/shared_pref_service.dart';

// holds current language state and notifies listeners on change
// also listens to system language changes
class LanguageState with ChangeNotifier {
  final SharedPrefsService _prefs = SharedPrefsService();
  late Locale _currentLanguage;

  void Function(Locale) _callback = (locale) {};

  void setCallback(void Function(Locale) callback) {
    _callback = callback;
  }

  Future<void> getLanguageFromLocalStorage(
    SharedPrefsService localStorage,
  ) async {
    final savedLang = localStorage.getString(Constants.languageKey);
    if (savedLang != null) {
      _currentLanguage = Locale(savedLang);
      setLanguage(_currentLanguage.languageCode);
    }
  }

  // set up listener for system language changes
  // and get initial language from local storage
  // if not found, use system preference
  LanguageState.initiateState() {
    ui.PlatformDispatcher.instance.onLocaleChanged = () {
      print(
        'System locale changed to ${ui.PlatformDispatcher.instance.locale}',
      );
      // final prefs = localStorage;
      final savedLang = _prefs.getString(Constants.languageKey);
      if (savedLang != null) {
        _currentLanguage = Locale(savedLang);
        setLanguage(_currentLanguage.languageCode);
        return;
      }

      _currentLanguage = LanguageUtils.bestSupportedLanguage();
      setLanguage(_currentLanguage.languageCode, localStore: _prefs);
    };
    getLanguageFromLocalStorage(_prefs);
  }

  void setLanguage(String lang, {SharedPrefsService? localStore}) {
    _currentLanguage = Locale(lang);
    _callback.call(_currentLanguage);
    if (localStore != null) {
      localStore.remove(Constants.languageKey);
    }
    notifyListeners();
  }
}
