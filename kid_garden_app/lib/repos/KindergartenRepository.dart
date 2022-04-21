

import 'package:geolocator/geolocator.dart';
import 'package:kid_garden_app/domain/Kindergraten.dart';
import 'package:tuple/tuple.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/models/MultiResponse.dart';
import '../data/network/models/SingleResponse.dart';
import '../domain/HomeModel.dart';
import '../presentation/ui/general_components/KindergratenCard.dart';

class KindergartenRepository{


  final BaseApiService _apiService = NetworkApiService();

  Future<Tuple2<List<Kindergraten>, bool>> getMyKindergartenList({required Position? position,required int page, String? searchKey}) async {
    try {

      var url="Kindergarten/getAll/$page";
      if(searchKey!=null && searchKey.trim().isNotEmpty) {
        url+="?query=$searchKey";
      }
      if(position!=null){
        url+="?longitude=${position.longitude}&latitude=${position.latitude}";


      }
      dynamic response = await _apiService.getResponse(url);

      bool isLastPage = false;

      var kindergartens;
      var mainResponse =
      MultiResponse<List<Kindergraten>>.fromJson(await response, (jsonList) {
        if (jsonList != null) {
          kindergartens = (jsonList as List).map((i) => Kindergraten.fromJson(i)).toList();
          return kindergartens;
        } else {
          throw "no Data Available";
        }
      });
      var nextPageTotal = (page) * 20;
      if (nextPageTotal >= (mainResponse.count)) {
        isLastPage = true;
      }

      if (await kindergartens.isNotEmpty) {
        return Tuple2(await kindergartens, isLastPage);
      } else {
        throw "no Data Available";
      }
      // var jsonObject = json.decode(object!) as List;
      // kindergartens = (jsonObject).map((i) => Child.fromJson(i)).toList();
    } catch (e) {
      rethrow;
    }
  }
  Future<HomeModel> getHome() async {
    try {
      dynamic response = await _apiService.getResponse("Kindergarten/getHome");
      var data;
      SingleResponse<HomeModel>.fromJson(await response, (json) {
        data = HomeModel.fromJson(json as Map<String, dynamic>);
        return data;
      });
      return await data;
    } catch (e) {
      rethrow;
    }
  }
}