import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kid_garden_app/data/network/models/ErrorResponse.dart';
import '../../providers/Providers.dart';
import 'AppException.dart';
import 'BaseApiService.dart';

class NetworkApiService extends BaseApiService {
  var jsonHeaders = {
    "Content-type": "application/json",
    "Accept": "application/json",
    "charset": "utf-8"
  };

  @override
  Future getResponse(String url) async {
    dynamic responseJson;
    try {
      var provide = ProviderContainer().read(LoginPageViewModelProvider);
      await provide.getUserChanges();
      var user = provide.currentUser;
      if (user != null) {
        jsonHeaders.addAll({'Authorization': "Bearer ${user.token}"});
      }

      final response =
          await http.get(Uri.parse(baseUrl + url), headers: jsonHeaders);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postResponse(String url, Map<String, dynamic> JsonBody) async {
    dynamic responseJson;
    try {
      var provide = ProviderContainer().read(LoginPageViewModelProvider);
      await provide.getUserChanges();
      var user = provide.currentUser;
      if (user != null) {
        final response = await http.post(Uri.parse(baseUrl + url),
            body: JsonBody,
            headers: {
              'Content-Type': 'multipart/form-data',
              'Authorization': "Bearer ${user.token}"
            },
            encoding: Encoding.getByName("utf-8"));
        responseJson = returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future multiPartPostResponse(String url, Map<String, String> JsonBody) async {
    dynamic responseJson;
    try {
      var provide = ProviderContainer().read(LoginPageViewModelProvider);
      await provide.getUserChanges();
      var user = provide.currentUser;
      if (user != null) {
        var headers = {
          'Content-Type': 'multipart/form-data',
          'Authorization': "Bearer ${user.token}"
        };
        var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));

        request.fields.addAll(JsonBody);
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

          responseJson =
              returnResponse(await http.Response.fromStream(response));


      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postResponseJsonBody(String url, String JsonBody) async {
    dynamic responseJson;

    try {
      var user =
          ProviderContainer().read(LoginPageViewModelProvider).currentUser;

      if (user != null) {
        jsonHeaders.addAll({'Authorization': user.token});
      }

      final response = await http.post(Uri.parse(baseUrl + url),
          body: JsonBody, headers: jsonHeaders);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw ErrorResponse.fromJson(jsonDecode(response.body));
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UrlNotFoundException(response.body.toString());
      case 415:
        throw ErrorDuringCommunication(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}
