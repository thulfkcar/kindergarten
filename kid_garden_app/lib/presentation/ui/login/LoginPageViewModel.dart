import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/di/Modules.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/repos/UserRepo.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../data/network/FromData/User.dart';
import '../../main.dart';

class LoginPageViewModel extends ChangeNotifier {
  var userRepo = UserRepository();

  ApiResponse<UserModel> userApiResponse = ApiResponse.non();

  void setUserApiResponse(ApiResponse<UserModel> apiResponse) async {
    userApiResponse = apiResponse;
    await Future.delayed(Duration(milliseconds: 1)); // use await

    notifyListeners();
  }

  Future<void> auth({required LoginFormData loginRequestData}) async {
    setUserApiResponse(ApiResponse.loading());
    await userRepo
        .auth(
            userName: loginRequestData.email,
            password: loginRequestData.password)
        .then((value) async {
      ProviderContainer().read(hiveProvider).value!.storeUser(value);
      setUserApiResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setUserApiResponse(ApiResponse.error(error.toString()));
    }).whenComplete(() => {});
  }

  authByPhone({required LoginForm loginRequestData}) async {
    setUserApiResponse(ApiResponse.loading());
    await userRepo.authByPhone(loginForm: loginRequestData).then((value) async {
      ProviderContainer().read(hiveProvider).value!.storeUser(value);
      setUserApiResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setUserApiResponse(ApiResponse.error(error.toString()));
    });
  }
}
