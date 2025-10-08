import 'dart:io';

import 'package:http/http.dart' as http;
import '../../app/configuration/app_url.dart';
import '../../services/base_api_services.dart';
import '../../services/network_api_service.dart';
import '../models/app_update_model.dart';

class AppUpdateDataProvider {
  final BaseApiServices _apiServices = NetworkApiService(http.Client());

  Future<List<UpdateInfo>> fetchAppVersions() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return [
      UpdateInfo(
        appType: Platform.isAndroid ? 'android' : 'ios',
        minVersion: '1.0.0', // <— installed below this => mandatory
        maxVersion: '1.0.0', // <— installed < this => flexible
      ),
    ];
    // try {
    //   dynamic response = await _apiServices.getGetApiResponse(
    //       AppUrl.appVersionApi);
    //   return response;
    // } catch (e) {
    //   rethrow;
    // }
  }
}
