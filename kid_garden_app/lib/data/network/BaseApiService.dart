import 'dart:io';


abstract class BaseApiService {

  final String baseUrl = domain+"api/";

  Future<dynamic> getResponse(String url);
  Future<dynamic> postResponse(String url,Map<String, dynamic> jsonBody);
  Future<dynamic> multiPartPostResponseSingleFile(String url,Map<String, String> jsonBody,File? assets);
  Future<dynamic> multiPartPostResponseMultiFiles(String url,Map<String, String> jsonBody,List<File>? assets);
  Future<dynamic> multiPartPostResponseNoFiles(String url,Map<String, String> jsonBody);
  Future<dynamic> postResponseJsonBody(String url,String jsonBody);


}
const String domain="http://5.182.33.67/";//online
// const String domain="http://192.168.1.25:81/";//offline
