import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/Redeem.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';
import 'package:kid_garden_app/repos/UserRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../data/network/FromData/User.dart';
import '../../../di/Modules.dart';

class LoginPageViewModel extends ChangeNotifier {
  var _childRepo = ChildRepository();
  var userRepo=UserRepository();

  ApiResponse<UserModel> userApiResponse = ApiResponse.non();
  ApiResponse<Redeem> userSubScribeApiResponse = ApiResponse.non();

  void setUserApiResponse(ApiResponse<UserModel> apiResponse) async {
    userApiResponse = apiResponse;
    await Future.delayed(Duration(milliseconds: 1)); // use await

    notifyListeners();
  }
  void setSubscribeApiResponse(ApiResponse<Redeem> apiResponse) async {
    userSubScribeApiResponse = apiResponse;
    await Future.delayed(Duration(milliseconds: 1)); // use await

    notifyListeners();
  }

  UserModel? currentUser = null;

  Future<UserModel?> getUserChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var userJson = prefs.getString("User");
      if (userJson != null && userJson != 'null') {
        Map<String, dynamic> userMap = jsonDecode(userJson);
        currentUser = UserModel.fromJson(userMap);
        notifyListeners();
        return currentUser;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> auth({required LoginFormData loginRequestData}) async {
    setUserApiResponse(ApiResponse.loading());
    await _childRepo
        .auth(
            userName: loginRequestData.email,
            password: loginRequestData.password)
        .then((value) async {
      await setUser(value);
      setUserApiResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      ApiResponse.error(error.toString());
    }).whenComplete(() => {});
  }
  Future<void> subscribe({required String subscription}) async {
    setSubscribeApiResponse(ApiResponse.loading());
    await userRepo
        .subscribe(subscription)
        .then((value) async {

      setSubscribeApiResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {

      setSubscribeApiResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> logOut() async {
    await setUser(null);
    currentUser = null;
    notifyListeners();
  }

  setUser(UserModel? user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (user == null) {
        prefs.setString("User", 'null');
      } else {
        prefs.setString("User", user.toString());
        print(prefs.getString("User"));
      }
    } catch (e) {
      rethrow;
    }
  }

  authByPhone({required LoginForm loginRequestData}) async {
    setUserApiResponse(ApiResponse.loading());
    await _childRepo
        .authByPhone(loginForm: loginRequestData)
        .then((value) async {
      await setUser(value);
      setUserApiResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setUserApiResponse(ApiResponse.error(error.toString()));


    });
  }

  SginUp({required SignUpForm form}) {}


}
