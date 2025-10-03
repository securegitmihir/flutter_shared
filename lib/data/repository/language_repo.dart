import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data_provider/language_dp.dart';

class LanguageRepository {
  final LanguageDataProvider languageDataProvider;

  LanguageRepository(this.languageDataProvider);

  static const _namespaces = ['common', 'home', 'drawer'];

  static const Map<String, dynamic> _fallbackEn = {
    "common": {"appTitle": "Secure Health (Node split • backend)"},
    "drawer": {
      "home": "Home",
      "language": {"title": "Language"},
      "settings": "Settings",
      "help": "Help",
    },
    "home": {
      "greeting": "Hello {name}, welcome back!",
      "subtitle":
          "This is your personalized dashboard with statistics and actions.",
      "quickStats": {
        "title": "Quick Stats",
        "today": "Today",
        "week": "This Week",
        "total": "Total",
        "value": {"today": "5", "week": "27", "total": "312"},
      },
      "actions": {
        "title": "Actions",
        "newItem": "Add New",
        "upload": "Upload File",
        "analytics": "View Analytics",
      },
      "counter": {
        "title": "Counter",
        "description": "Press the button to increase the counter.",
        "increment": "Increment",
        "value": "Current count: {count}",
      },
      "learnMore": {
        "title": "Learn More",
        "body":
            "You can explore more features and insights by navigating through the app.",
      },
    },
  };

  // Pref keys
  static const _kLang = 'i18n_lang';
  static String _kVer(String lang) => 'i18n_ver_$lang';
  static String _kJson(String lang) => 'i18n_json_$lang';

  Future<Map<String, dynamic>> getLanguageJson(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    final _lang = prefs.getString(_kLang) ?? lang;
    final savedVer = prefs.getString(_kVer(_lang));
    final ns = _namespaces.join(',');

    try {
      final vRes = await languageDataProvider.getLanguageVersion(ns, _lang);

      if (vRes.statusCode == 200) {
        final remoteVer = (jsonDecode(vRes.body)['version'] ?? '').toString();

        final cached = prefs.getString(_kJson(lang));
        if (cached != null && remoteVer.isNotEmpty && remoteVer == savedVer) {
          return jsonDecode(cached) as Map<String, dynamic>;
        }

        final bRes = await languageDataProvider.getLanguageJson(ns, _lang);
        if (bRes.statusCode == 200) {
          await prefs.setString(_kJson(_lang), bRes.body);
          await prefs.setString(_kVer(_lang), remoteVer);
          return jsonDecode(bRes.body) as Map<String, dynamic>;
        }
      }
    } catch (e) {}
    final cached = prefs.getString(_kJson(_lang));
    if (cached != null) {
      return jsonDecode(cached) as Map<String, dynamic>;
    }
    return _fallbackEn;
  }
}
