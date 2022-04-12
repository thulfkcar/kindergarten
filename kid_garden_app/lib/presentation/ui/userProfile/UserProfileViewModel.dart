import 'package:flutter/material.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../domain/UserModel.dart';
import '../../../repos/UserRepo.dart';

class UserProfileViewModel extends ChangeNotifier {
  String userId;
  final UserRepository _repository = UserRepository();
  ApiResponse<UserModel> staffProfileResult = ApiResponse.non();

  UserProfileViewModel({required this.userId}) : super() {
    getUser(userId: userId);
  }

  void setStaffProfileResult(ApiResponse<UserModel> response){
    staffProfileResult=response;
    notifyListeners();
  }
  Future<void> getUser({required String userId}) async {
    setStaffProfileResult(ApiResponse.loading());
    _repository.getUser(id: userId).then((value) {
      setStaffProfileResult(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setStaffProfileResult(ApiResponse.error(error.toString()));
    });
  }
}
