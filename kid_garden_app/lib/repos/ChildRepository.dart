import 'dart:io';

import 'package:kid_garden_app/data/network/FromData/AssingChildForm.dart';
import 'package:kid_garden_app/data/network/FromData/ChildForm.dart';
import 'package:kid_garden_app/data/network/FromData/User.dart';
import 'package:kid_garden_app/data/network/models/ErrorResponse.dart';
import 'package:tuple/tuple.dart';

import '../data/network/models/MultiResponse.dart';
import 'package:kid_garden_app/data/network/models/SingleResponse.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/domain/UserModel.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';

class ChildRepository {
  ChildRepository();

  final BaseApiService _apiService = NetworkApiService();

  Future<Tuple2<List<Child>, bool>> getMyChildList({required int page, String? searchKey,String? subUserId}) async {
    try {
      Map<String, String> jsonBody = Map();

      var url="Child/getAll/$page";
      if(subUserId!=null){
        jsonBody.addAll({"UserId":subUserId});

      }
      if(searchKey!=null && searchKey.trim().isNotEmpty) {
        jsonBody.addAll({"ChildName":searchKey});
        // url+="?childName=$searchKey";
      }

      dynamic response = await _apiService.postResponse(url,jsonBody);

      bool isLastPage = false;

      var childes;
      var mainResponse =
          MultiResponse<List<Child>>.fromJson(await response, (jsonList) {
        if (jsonList != null) {
          childes = (jsonList as List).map((i) => Child.fromJson(i)).toList();
          return childes;
        } else {
          throw "no Data Available";
        }
      });
      var nextPageTotal = (page) * 20;
      if (nextPageTotal >= (mainResponse.count)) {
        isLastPage = true;
      }

      if (await childes.isNotEmpty) {
        return Tuple2(await childes, isLastPage);
      } else {
        throw "no Data Available";
      }
      // var jsonObject = json.decode(object!) as List;
      // childes = (jsonObject).map((i) => Child.fromJson(i)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Tuple2<List<Child>, bool>> getChildrenWithInfo(
      {required int page}) async {
    try {
      dynamic response = await _apiService
          .getResponse("Child/getLastActions/$page?actionsCount=4");
      bool isLastPage = false;

      var childes;
      var mainResponse =
          MultiResponse<List<Child>>.fromJson(await response, (jsonList) {
        if (jsonList != null) {
          childes = (jsonList as List).map((i) => Child.fromJson(i)).toList();
          return childes;
        } else {
          throw "no Data Available";
        }
      });
      var nextPageTotal = (page) * 20;
      if (nextPageTotal >= (mainResponse.count)) {
        isLastPage = true;
      }

      if (await childes.isNotEmpty) {
        return Tuple2(await childes, isLastPage);
      } else {
        throw "no Data Available";
      }
      // var jsonObject = json.decode(object!) as List;
      // childes = (jsonObject).map((i) => Child.fromJson(i)).toList();
    } catch (e) {
      rethrow;
    }
  }





  Future<Child> addChild(ChildForm childForm) async {
    try {
      Map<String, String> jsonBody = Map();
      jsonBody.addAll({
        "Name": childForm.childName!,
        "Gender": childForm.gender.toString(),
        "BirthDate": childForm.birthDate.toString()
      });
      List<File>? assest = null;
      assest = [childForm.imageFile!];
      dynamic response = await _apiService.multiPartPostResponse(
          "Child/add", jsonBody, assest);

      var child;
      SingleResponse<Child>.fromJson(await response, (json) {
        child = Child.fromJson(json as Map<String, dynamic>);
        return child;
      });
      return await child;
    } catch (e) {
      if (e is ErrorResponse) {
        throw e.errorMsg.toString();
      }
      rethrow;
    }
  }

  Future<bool> assignChild(AssignChildForm assignChildForm) async {
    try {
      dynamic response = await _apiService.postResponseJsonBody(
          "Child/assign", "{childId: '${assignChildForm.childID!}', userId: '${assignChildForm.staffId!}'}");
      var isAssign = ErrorResponse.fromJson(await response);
      return isAssign.status!;
    } catch (e) {
      if (e is ErrorResponse) {
        throw e.errorMsg.toString();
      }
      rethrow;
    }
  }

}
