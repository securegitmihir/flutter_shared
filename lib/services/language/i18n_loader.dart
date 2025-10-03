import 'dart:ui' show Locale;
import 'package:assisted_living/data/repository/language_repo.dart';
import 'package:easy_localization/easy_localization.dart';

class NetworkAssetLoader extends AssetLoader {
  const NetworkAssetLoader(this.repository);
  final LanguageRepository repository;

  @override
  Future<Map<String, dynamic>> load(String _, Locale locale) async {
    final lang = locale.languageCode.toString();
    return await repository.getLanguageJson(lang);
  }
}
