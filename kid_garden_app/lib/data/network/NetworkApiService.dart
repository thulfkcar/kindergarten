import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../di/Modules.dart';
import '../../domain/UserModel.dart';
import '../../presentation/main.dart';
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
      UserModel? user;
      providerContainerRef.read(hiveProvider).whenData((value) {
        if (value != null) {
          user = value.getUser();
          if (user != null) {
            jsonHeaders.addAll({'Authorization': "Bearer ${user!.token}"});
          }
        }
      });

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
      UserModel? user;
      providerContainerRef.read(hiveProvider).whenData((value) async {
        if (value != null) {
          user = value.getUser();
        }
      });
      if (user != null) {
        final response = await http.post(Uri.parse(baseUrl + url),
            body: JsonBody,
            headers: {
              // 'Content-Type': 'multipart/form-data',
              'Authorization': "Bearer ${user!.token}"
            },
            encoding: Encoding.getByName("utf-8"));
        responseJson = await returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future multiPartPostResponseSingleFile(
      String url, Map<String, String> jsonBody, File? assets) async {
    dynamic responseJson;
    try {
      var user = providerContainerRef.read(hiveProvider).value!.getUser();
      if (user != null) {
        var headers = {
          'Content-Type': 'multipart/form-data',
          'Authorization': "Bearer ${user.token}"
        };
        var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));

        if (assets != null) {
          request.files.add(
              await http.MultipartFile.fromPath('file', assets.path));
        }

        request.fields.addAll(jsonBody);
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        responseJson = returnResponse(await http.Response.fromStream(response));
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future multiPartPostResponseMultiFiles(
      String url, Map<String, String> jsonBody, List<File>? assets) async {
    dynamic responseJson;
    try {
      var user = providerContainerRef.read(hiveProvider).value!.getUser();
      if (user != null) {
        var headers = {
          'Content-Type': 'multipart/form-data',
          'Authorization': "Bearer ${user.token}"
        };
        var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));

        if (assets != null) {
          for (var element in assets) {
            request.files
                .add(await http.MultipartFile.fromPath('files', element.path));
          }
        }

        request.fields.addAll(jsonBody);
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        responseJson = returnResponse(await http.Response.fromStream(response));
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future multiPartPostResponseNoFiles(
      String url, Map<String, String> jsonBody) async {
    dynamic responseJson;
    try {
      var user = providerContainerRef.read(hiveProvider).value!.getUser();
      if (user != null) {
        var headers = {
          'Content-Type': 'multipart/form-data',
          'Authorization': "Bearer ${user.token}"
        };

        var request = http.MultipartRequest('POST', Uri.parse(baseUrl + url));
        request.fields.addAll(jsonBody);
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();

        responseJson = returnResponse(await http.Response.fromStream(response));
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
      UserModel? user;
      providerContainerRef.read(hiveProvider).whenData((value) async {
        if (value != null) {
          user = value.getUser();

          if (user != null) {
            jsonHeaders.addAll({'Authorization': "Bearer ${user!.token}"});
          }
        }
      });

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
        throw response.body.toString();
      case 401:
      case 403:
      case 402:
      case 405:
        throw response.body.toString();
      case 404:
        throw UrlNotFoundException(response.body.toString());
      case 415:
        throw ErrorDuringCommunication(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Error occured while communication with server' +
            ' with status code : ${response.statusCode}     ${response.body}');
    }
  }
}
