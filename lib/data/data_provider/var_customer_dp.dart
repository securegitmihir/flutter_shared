import 'package:http/http.dart';

import '../../services/app_url.dart';
import '../../services/base_api_services.dart';
import '../../services/network_api_service.dart';

class VarCustomerDataProvider {
  final BaseApiServices _apiServices = NetworkApiService(Client());

  Future<dynamic> validateCustomerMobile(data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.validateCustomerMobile, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}