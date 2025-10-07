import 'package:assisted_living/app/routes/app_routes.dart';
import 'package:assisted_living/services/constants.dart';
import 'package:assisted_living/services/language/language_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelectorScreen extends StatelessWidget {
  const LanguageSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = Constants.supportedLanguages;

    final langState = context.read<LanguageState>();
    final current = context.locale.languageCode;
    return Scaffold(
      appBar: AppBar(title: Text('Select Language')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...options.map((o) {
            final selected = o.code == current;
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  Navigator.pop(context);
                  langState.setLanguage(o.code);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Language changed to ${o.name}')),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Text(
                      o.emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                    title: Text(
                      o.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(o.native),
                    trailing: Icon(
                      selected ? Icons.check_circle : Icons.circle_outlined,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
