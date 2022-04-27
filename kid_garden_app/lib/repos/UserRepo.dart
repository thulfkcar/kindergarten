import 'dart:io';
import 'package:kid_garden_app/data/network/FromData/StaffAddingForm.dart';
import 'package:kid_garden_app/data/network/FromData/User.dart';
import 'package:kid_garden_app/domain/AssignRequest.dart';
import 'package:kid_garden_app/domain/Redeem.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:tuple/tuple.dart';
import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/models/ErrorResponse.dart';
import '../data/network/models/MultiResponse.dart';
import '../data/network/models/SingleResponse.dart';

class UserRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future<UserModel> addStaff({required StaffAddingForm staffAddingForm}) async {
    try {
      Map<String, String> jsonBody = Map();
      jsonBody.addAll({
        "Name": staffAddingForm.name.toString(),
        "Password": staffAddingForm.password.toString(),
        "Email": staffAddingForm.email.toString(),
        "Role": '1',
        "Phone": staffAddingForm.phoneNumber!
      });
      List<File>? assest;
      if (staffAddingForm.image != null) {
        assest = [staffAddingForm.image!];
      }
      dynamic response =
          await _apiService.multiPartPostResponse("user/add", jsonBody, assest);

      var user;
      SingleResponse<UserModel>.fromJson(await response, (json) {
        user = UserModel.fromJson(json as Map<String, dynamic>);
        return user;
      });
      return await user;
    } catch (e) {
      if (e is ErrorResponse) {
        throw e.errorMsg.toString();
      }
      rethrow;
    }
  }

  Future<Tuple2<List<UserModel>, bool>> getMyStaffList(
      {required int page}) async {
    try {
      dynamic response = await _apiService.getResponse("User/getAll/$page/1");
      bool isLastPage = false;

      var staffs;
      var mainResponse =
          MultiResponse<List<UserModel>>.fromJson(await response, (jsonList) {
        if (jsonList != null) {
          staffs =
              (jsonList as List).map((i) => UserModel.fromJson(i)).toList();
          return staffs;
        } else {
          throw "no Data Available";
        }
      });
      var nextPageTotal = (page) * 20;
      if (nextPageTotal >= (mainResponse.count)) {
        isLastPage = true;
      }

      if (await staffs.isNotEmpty) {
        return Tuple2(await staffs, isLastPage);
      } else {
        throw "no Data Available";
      }
      // var jsonObject = json.decode(object!) as List;
      // childes = (jsonObject).map((i) => Child.fromJson(i)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Tuple2<List<UserModel>, bool>> getMyParentsList(
      {required int page, required String? searchKey}) async {
    try {
      dynamic response = await _apiService.getResponse("User/getAll/$page/2");
      bool isLastPage = false;

      var staffs;
      var mainResponse =
          MultiResponse<List<UserModel>>.fromJson(await response, (jsonList) {
        if (jsonList != null) {
          staffs =
              (jsonList as List).map((i) => UserModel.fromJson(i)).toList();
          return staffs;
        } else {
          throw "no Data Available";
        }
      });
      var nextPageTotal = (page) * 20;
      if (nextPageTotal >= (mainResponse.count)) {
        isLastPage = true;
      }

      if (await staffs.isNotEmpty) {
        return Tuple2(await staffs, isLastPage);
      } else {
        throw "no Data Available";
      }
      // var jsonObject = json.decode(object!) as List;
      // childes = (jsonObject).map((i) => Child.fromJson(i)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUser({required String id}) async {
    try {
      var response = await _apiService.getResponse("User/GetUser/$id");
      var user;
      SingleResponse<UserModel>.fromJson(await response, (json) {
        user = UserModel.fromJson(json as Map<String, dynamic>);
        return user;
      });
      return await user;
    } catch (e) {
      rethrow;
    }
  }

  Future<Redeem> subscribe(String subscription) async {
    try {
      var response = await _apiService.postResponse(
          "Subscription/subscribe/$subscription", Map());
      var result;
      SingleResponse<Redeem>.fromJson(await response, (json) {
        result = Redeem.fromJson(json as Map<String, dynamic>);
        return result;
      });
      return await result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> checkSubscription() async {
    try {
      var response =
          await _apiService.getResponse("Subscription/CheckSubscription");
      var result;
      SingleResponse<String>.fromJson(await response, (json) {
        result = json.toString();
        return result;
      });
      return await result;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> auth(
      {required String userName, required String password}) async {
    try {
      dynamic response = await _apiService.postResponseJsonBody(
          "User/login", "{email: '$userName', password: '$password'}");
      var user;
      SingleResponse<UserModel>.fromJson(await response, (json) {
        user = UserModel.fromJson(json as Map<String, dynamic>);
        return user;
      });
      return await user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> authByPhone({required LoginForm loginForm}) async {
    try {
      dynamic response = await _apiService.postResponseJsonBody(
          "User/loginByPhone", "{phone: '${loginForm.phoneNumber}'}");
      var user;
      SingleResponse<UserModel>.fromJson(await response, (json) {
        user = UserModel.fromJson(json as Map<String, dynamic>);
        return user;
      });
      return await user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signUp(SignUpForm form) async {
    try {
      String jsonBody =
          '{"phone": "${form.phoneNumber}","name": "${form.fullName}"}';
      var response =
          await _apiService.postResponseJsonBody("User/Register", jsonBody);

      var user;
      SingleResponse<UserModel>.fromJson(await response, (json) {
        user = UserModel.fromJson(json as Map<String, dynamic>);
        return user;
      });
      return await user;
    } catch (e) {
      rethrow;
    }
  }

  Future<AssignRequest> requestToKindergarten(
      String childId, String requestedKindergartenId) async {
    try {
      var response = await _apiService.postResponse(
          'User/assignRequest?Child=$childId&KindergartenId=$requestedKindergartenId',
          Map());
      var result;
      SingleResponse<AssignRequest>.fromJson(await response, (json) {
        result = AssignRequest.fromJson(json as Map<String, dynamic>);
        return result;
      });
      return await result;

    } catch (e) {
      rethrow;
    }
  }
}
