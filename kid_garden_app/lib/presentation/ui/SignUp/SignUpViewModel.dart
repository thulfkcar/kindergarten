import 'package:flutter/material.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/data/network/FromData/User.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/repos/UserRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpViewModel extends ChangeNotifier {
  var repository = UserRepository();

  ApiResponse<UserModel> signUpApiResponse = ApiResponse.non();

  void setSignUpApiResponse(ApiResponse<UserModel> response) {
    signUpApiResponse = response;
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
  Future<void> signUp(SignUpForm form) async {
    setSignUpApiResponse(ApiResponse.loading());
    await repository.signUp(form).then((value) {
      setUser(value);
      setSignUpApiResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setSignUpApiResponse(ApiResponse.error(error.toString()));
    });
  }
}
