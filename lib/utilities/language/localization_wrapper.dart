import 'package:assisted_living/data/data_provider/language_dp.dart';
import 'package:assisted_living/data/repository/language_repo.dart';
import 'package:assisted_living/app/configuration/constants.dart';
import 'package:assisted_living/utilities/language/i18n_loader.dart';
import 'package:assisted_living/utilities/language/language_state.dart';
import 'package:assisted_living/utilities/language/language_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationWrapper extends StatelessWidget {
  final Widget child;

  const LocalizationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // check if locally saved
    final prefs = context.read<SharedPreferences>();
    final savedLang = prefs.getString(Constants.language_key);

    // first time user gets system preference
    final systemBest = LanguageUtils.bestSupportedLanguage();

    return EasyLocalization(
      supportedLocales: Constants.supportedLanguages
          .map((e) => Locale(e.code))
          .toList(),
      fallbackLocale: systemBest,
      startLocale: savedLang != null ? Locale(savedLang) : systemBest,
      assetLoader: NetworkAssetLoader(
        LanguageRepository(LanguageDataProvider()),
      ),
      path: 'unused',
      child: Builder(
        builder: (context) {
          // register callback to be executed everytime language changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final langState = context.read<LanguageState>();
            langState.setCallback((locale) {
              context.setLocale(locale);
              prefs.setString(Constants.language_key, locale.languageCode);
            });
          });
          return child;
        },
      ),
    );
  }
}
