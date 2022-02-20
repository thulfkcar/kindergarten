import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/User.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../data/network/models/LoginRequestData.dart';
import '../../../providers/Providers.dart';

class LoginPageViewModel extends ChangeNotifier {
  var _childRepo = ChildRepository();

  ApiResponse<User> userApiResponse = ApiResponse.non();

  void setUserApiResponse(ApiResponse<User> apiResponse) {
    userApiResponse = apiResponse;
    notifyListeners();
  }

  User? currentUser = null;

  Future<void> getUserChanges() async {

    final prefs = await SharedPreferences.getInstance();
    var userJson = prefs.getString("User");
    if (userJson != null && userJson !='null') {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      currentUser=  User.fromJson(userMap);

      notifyListeners();
    }


  }

  Future<void> auth({required LoginRequestData loginRequestData}) async {
    setUserApiResponse(ApiResponse.loading());
    Future.delayed(const Duration(milliseconds: 1000), () {
      _childRepo
          .auth(
              userName: loginRequestData.email,
              password: loginRequestData.password)
          .then((value) async {
        await setUser(value);
        setUserApiResponse(ApiResponse.completed(value));
      }).onError((error, stackTrace) {
        ApiResponse.error(error.toString());
      });
    });
  }
}
