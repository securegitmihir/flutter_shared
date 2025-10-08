import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../utilities/app_exception.dart';
import 'base_api_services.dart';
import '../app/configuration/constants.dart';
import 'log_service.dart';

const duration = Duration(seconds: Constants.apiTimeout);

class NetworkApiService extends BaseApiServices {
  late Client httpClient;
  dynamic jwtToken, sessionId;

  NetworkApiService(this.httpClient);

  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      await LogService.logActivity("?? GET Request: $url");
      final response = await httpClient.get(Uri.parse(url)).timeout(duration);
      responseJson = returnResponse(response);
      print("GOT DATA IN RESPONSE :::::$responseJson");
      await LogService.logActivity(
        "? GET Response [${response.statusCode}]: ${response.body}",
      );
    } on SocketException {
      await LogService.logActivity("? GET Request Failed: Network Error");
      throw FetchDataException('');
    } catch (e) {
      await LogService.logActivity("? GET Request Failed: $e");
      throw SomethingWentWrongException(e.toString());
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      print("SENDING DATA IN REQUEST :::::$url $data");
      // final String userResponseString = await GetStorageUtils.getString(
      //     kUserResponseModel, '');
      // if (userResponseString.isNotEmpty) {
      //   final userResponseModel = UserResponseModel.fromJson(
      //       jsonDecode(userResponseString));
      //   jwtToken = userResponseModel.jwtToken;
      //   sessionId = userResponseModel.sessionid;
      // }
      String requestData = json.encode(data);
      await LogService.logActivity(
        "📡 POST Request: $url - Data: $requestData",
      );
      Response response = await httpClient
          .post(Uri.parse(url), body: json.encode(data), headers: addHeaders())
          .timeout(duration);
      responseJson = returnResponse(response);
      print("GOT DATA IN RESPONSE :::::$responseJson");
      await LogService.logActivity(
        "? POST Response [${response.statusCode}]: ${response.body}",
      );
    } on SocketException {
      await LogService.logActivity("? POST Request Failed: Network Error");
      throw FetchDataException('');
    } on UnauthorizedException {
      print('unauthorized');
      await LogService.logActivity(
        "? POST Request Failed: Authentication Error",
      );
      await HydratedBloc.storage.clear();
      throw UnauthorizedException('');
    } catch (e) {
      await LogService.logActivity("? POST Request Failed: $e");
      throw SomethingWentWrongException('');
    }
    return responseJson;
  }

  @override
  Future getUrlEncodedPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      print("SENDING DATA IN REQUEST :::::$data");
      final body = data.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}',
          )
          .join('&');
      // final String userResponseString = await GetStorageUtils.getString(kUserResponseModel, '');
      // if (userResponseString.isNotEmpty) {
      //   final userResponseModel = UserResponseModel.fromJson(jsonDecode(userResponseString));
      //   jwtToken = userResponseModel.jwtToken;
      //   sessionId = userResponseModel.sessionid;
      // }
      await LogService.logActivity(
        "📡 POST (URL-Encoded) Request: $url - Data: $body",
      );
      Response response = await httpClient
          .post(Uri.parse(url), body: body, headers: addUrlEncodedHeader())
          .timeout(duration);
      responseJson = returnResponse(response);
      await LogService.logActivity(
        "✅ POST (URL-Encoded) Response [${response.statusCode}]: ${response.body}",
      );
      print("GOT DATA IN RESPONSE :::::$responseJson");
      await LogService.logActivity(
        "? POST (URL-Encoded) Response [${response.statusCode}]: ${response.body}",
      );
    } on SocketException {
      print('sockect Exception');
      await LogService.logActivity(
        "❌ POST (URL-Encoded) Request Failed: Network Error",
      );
      throw FetchDataException('');
    } on UnauthorizedException {
      print('unauthorized');
      await LogService.logActivity(
        "❌ POST (URL-Encoded) Request Failed: Authentication Error",
      );
      await HydratedBloc.storage.clear();
      throw UnauthorizedException('');
    } catch (e) {
      print('Exception ${e.toString()}');
      await LogService.logActivity("❌ POST (URL-Encoded) Request Failed: $e");
      throw SomethingWentWrongException('');
    }
    return responseJson;
  }

  dynamic returnResponse(Response response) {
    print('Status code ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException('');
      case 401:
        throw UnauthorizedException('');
      case 500:
        throw InternalServerException('');
      default:
        throw FetchDataException('');
    }
  }

  dynamic addHeaders() {
    Map<String, String> data = {};
    data.putIfAbsent('Content-Type', () => 'application/json');
    if (sessionId != null)
      data.putIfAbsent('Session-id', () => sessionId.toString());
    if (jwtToken != null)
      data.putIfAbsent('Authorization', () => "Bearer $jwtToken");
    data.putIfAbsent('Request-id', () => '1');

    return data;
  }

  dynamic addUrlEncodedHeader() {
    Map<String, String> data = {};
    data.putIfAbsent('Content-Type', () => 'application/x-www-form-urlencoded');
    if (sessionId != null)
      data.putIfAbsent('Session-id', () => sessionId.toString());
    if (jwtToken != null)
      data.putIfAbsent('Authorization', () => "Bearer $jwtToken");
    data.putIfAbsent('Request-id', () => '1');
    return data;
  }
}
