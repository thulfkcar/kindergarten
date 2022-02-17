import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/domain/User.dart';
import 'package:kid_garden_app/network/ApiResponse.dart';
import 'package:kid_garden_app/network/models/LoginRequestData.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

class LoginPageViewModel extends ChangeNotifier {
  var _childRepo = ChildRepository();

  ApiResponse<User> userApiResponse = ApiResponse.non();

  void setUserApiResponse(ApiResponse<User> apiResponse) {
    userApiResponse = apiResponse;
    notifyListeners();
  }

  Future<void> auth({required LoginRequestData loginRequestData}) async {
    setUserApiResponse(ApiResponse.loading());
    Future.delayed(const Duration(milliseconds: 1000), () {
      _childRepo
          .auth(
              userName: loginRequestData.email,
              password: loginRequestData.password)
          .then((value) => setUserApiResponse(ApiResponse.completed(value)))
          .onError((error, stackTrace) => ApiResponse.error(error.toString()));
    });
  }
}
