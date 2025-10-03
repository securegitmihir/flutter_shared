import 'package:assisted_living/services/language/language_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSelectorScreen extends StatelessWidget {
  const LanguageSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Language')),
      body: Center(
        child: Consumer<LanguageState>(
          builder: (context, languageProvider, child) {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Change language to English
                    languageProvider.setLanguage('en');
                    context.setLocale(const Locale('en'));
                  },
                  child: const Text('English'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Change language to Hindi
                    languageProvider.setLanguage('hi');
                    context.setLocale(const Locale('hi'));
                  },
                  child: const Text('Hindi'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
