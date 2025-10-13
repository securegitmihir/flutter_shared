import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utilities/language/language_state.dart';

class LanguageSelectorScreen extends StatelessWidget {
  const LanguageSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = const [
      _Lang(
        code: 'en',
        locale: Locale('en'),
        emoji: '🇺🇸',
        name: 'English',
        native: 'English',
      ),
      _Lang(
        code: 'hi',
        locale: Locale('hi'),
        emoji: '🇮🇳',
        name: 'Hindi',
        native: 'हिन्दी',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Select Language')),
      body: Consumer<LanguageState>(
        builder: (context, langState, _) {
          final current = context.locale.languageCode;
          return ListView(
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
                      await context.setLocale(o.locale);
                      if(!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Language changed to ${o.name}'),
                        ),
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
          );
        },
      ),
    );
  }
}

class _Lang {
  final String code;
  final Locale locale;
  final String emoji;
  final String name;
  final String native;
  const _Lang({
    required this.code,
    required this.locale,
    required this.emoji,
    required this.name,
    required this.native,
  });
}
