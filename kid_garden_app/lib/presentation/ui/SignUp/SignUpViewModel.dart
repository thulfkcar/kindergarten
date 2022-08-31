import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/data/network/FromData/User.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/repos/UserRepo.dart';

import '../../../di/Modules.dart';
import '../../main.dart';

class SignUpViewModel extends ChangeNotifier {
  var repository = UserRepository();

  ApiResponse<UserModel> signUpApiResponse = ApiResponse.non();

  void setSignUpApiResponse(ApiResponse<UserModel> response) {
    signUpApiResponse = response;
    notifyListeners();
  }
  Future<void> signUp(SignUpForm form) async {
    setSignUpApiResponse(ApiResponse.loading());
    await repository.signUp(form).then((value) {
      providerContainerRef.read(hiveProvider).value!.storeUser(value);

      setSignUpApiResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setSignUpApiResponse(ApiResponse.error(error.toString()));
    });
  }
}
