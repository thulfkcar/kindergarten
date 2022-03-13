
import 'package:kid_garden_app/data/network/FromData/ChildForm.dart';
import 'package:kid_garden_app/data/network/models/ErrorResponse.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../data/network/models/MultiResponse.dart';
import 'package:kid_garden_app/data/network/models/SingleResponse.dart';
import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import 'package:kid_garden_app/domain/User.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';

class ChildRepository {
  ChildRepository();

  final BaseApiService _apiService = NetworkApiService();
  Future<List<Child>> getMyChildList() async {
    try {
      dynamic response = await _apiService.getResponse("Child/getAll/1");

      var childes;
      MultiResponse<List<Child>>.fromJson(await response, (jsonList) {
        if (jsonList != null) {
          childes = (jsonList as List).map((i) => Child.fromJson(i)).toList();
          return childes;
        } else {
          throw "no Data Available";
        }
      });
      if (await childes.isNotEmpty) {
        return await childes;
      } else {
        throw "no Data Available";
      }
      // var jsonObject = json.decode(object!) as List;
      // childes = (jsonObject).map((i) => Child.fromJson(i)).toList();
    } catch (e) {
      rethrow;
    }
  }
  Future<List<Child>> getChildrenWithInfo() async {
    try {
      List<Child> children = [];

      return children;
    } catch (e) {
      rethrow;
    }
  }
  Future<User?> auth({required String userName, required String password}) async {
    try {
      dynamic response = await _apiService.postResponseJsonBody(
          "User/login", "{email: '$userName', password: '$password'}");
        var user;
        SingleResponse<User>.fromJson(await response, (json) {
          user = User.fromJson(json as Map<String, dynamic>);
          return user;
        });
        return await user;
    } catch (e) {
      rethrow;
    }
  }
  Future<List<Child>> getChildren() async {
    return await getMyChildList();
  }

  Future<Child> addChild(ChildForm childForm) async {
    try {
      Map<String, String> jsonBody = Map();
      jsonBody.addAll({
        "Name": childForm.childName,
        "Gender": childForm.gender.toString(),
        "BirthDate": childForm.birthDate.toString()
      });
      List<AssetEntity>? assest=null;
      assest=[childForm.imageFile];
      dynamic response = await _apiService.multiPartPostResponse(
          "Child/add", jsonBody, assest);

      var child;
      SingleResponse<Child>.fromJson(await response, (json) {
        child = Child.fromJson(json as Map<String, dynamic>);
        return child;
      });
      return await child;
    }
    catch(e){
      if(e is ErrorResponse) {
        throw e.errorMsg.toString();
      }
      rethrow;
    }
  }

}
