import 'dart:io';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

abstract class BaseApiService {

  final String baseUrl = domain+"api/";

  Future<dynamic> getResponse(String url);
  Future<dynamic> postResponse(String url,Map<String, dynamic> jsonBody);
  Future<dynamic> multiPartPostResponse(String url,Map<String, String> jsonBody,List<File>? assets);
  Future<dynamic> multiPartPostResponseNoFiles(String url,Map<String, String> jsonBody);
  Future<dynamic> postResponseJsonBody(String url,String jsonBody);


}
const String domain="http://5.182.33.67/";
