import 'package:http/http.dart';

import '../../app/configuration/app_url.dart';
import '../../services/base_api_services.dart';
import '../../services/network_api_service.dart';

class LanguageDataProvider {
  final BaseApiServices _apiServices = NetworkApiService(Client());

  Future<dynamic> getLanguageJson(String namespaces, String lang) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
        AppUrl.getLanguageJson(lang, namespaces),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getLanguageVersion(String namespaces, String lang) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
        AppUrl.getLanguageVersion(lang, namespaces),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
