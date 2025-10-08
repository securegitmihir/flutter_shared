import 'package:http/http.dart';

import '../../app/configuration/app_url.dart';
import '../../services/base_api_services.dart';
import '../../services/network_api_service.dart';

class OTPVerificationDataProvider {
  final BaseApiServices _apiServices = NetworkApiService(Client());

  Future<String> getOTP(loginId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
        '${AppUrl.getOTP}/$loginId',
      );
      return response["response"];
    } catch (e) {
      rethrow;
    }
  }
}
