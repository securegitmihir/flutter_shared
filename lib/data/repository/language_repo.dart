import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data_provider/language_dp.dart';
import 'package:assisted_living/services/fallback_strings.dart';

class LanguageRepository {
  final LanguageDataProvider languageDataProvider;
  const LanguageRepository(this.languageDataProvider);

  static const _namespaces = ['common', 'home', 'drawer'];

  // Pref keys
  static const _kLang = 'i18n_lang';
  static String _kVer(String lang) => 'i18n_ver_$lang';
  static String _kJson(String lang) => 'i18n_json_$lang';

  Future<Map<String, dynamic>> getLanguageJson(String lang) async {
    if (lang != 'en') {
      return fallbackHi;
    }
    return fallbackEn;
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
    return fallbackEn;
  }
}
