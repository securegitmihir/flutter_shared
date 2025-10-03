import 'package:http/http.dart';

import '../../services/app_url.dart';
import '../../services/base_api_services.dart';
import '../../services/network_api_service.dart';

class CommonDataProvider {
  final BaseApiServices _apiServices = NetworkApiService(Client());
  Future<dynamic> getCountryCodeList(data) async {
    try {
      dynamic response = await _apiServices.getUrlEncodedPostApiResponse(
          AppUrl.countryCodeApi, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}