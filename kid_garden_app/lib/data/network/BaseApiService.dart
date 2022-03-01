abstract class BaseApiService {

  final String baseUrl = "http://5.182.33.67/api/";

  Future<dynamic> getResponse(String url);
  Future<dynamic> postResponse(String url,Map<String, dynamic> jsonBody);
  Future<dynamic> postResponseJsonBody(String url,String jsonBody);

}