import 'package:flutter/material.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../domain/Redeem.dart';
import '../../../repos/UserRepo.dart';

class SubscriptionViewModel extends ChangeNotifier {
  var userRepo = UserRepository();
var check=false;

  SubscriptionViewModel(this.check):super(){

    if(check){
      checkParentSubscription();
    }
  }

  ApiResponse<Redeem> userSubScribeApiResponse = ApiResponse.non();
  ApiResponse<String> userSubscriptionStatusResponse = ApiResponse.non();

  void setSubscribeApiResponse(ApiResponse<Redeem> apiResponse) async {
    userSubScribeApiResponse = apiResponse;
    await Future.delayed(Duration(milliseconds: 1)); // use await

    notifyListeners();
  }

  setUserSubscriptionStatusResponse(ApiResponse<String> apiResponse) async {
    userSubscriptionStatusResponse = apiResponse;
    await Future.delayed(Duration(milliseconds: 1)); // use await

    notifyListeners();
  }

  Future<void> subscribe({required String subscription}) async {
    setSubscribeApiResponse(ApiResponse.loading());
    await userRepo.subscribe(subscription).then((value) async {
      setSubscribeApiResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setSubscribeApiResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> checkParentSubscription() async {
    await setUserSubscriptionStatusResponse(ApiResponse.loading());
    await userRepo
        .checkSubscription()
        .then((value) async { await setUserSubscriptionStatusResponse(
            ApiResponse.completed(value));})
        .onError((error, stackTrace) async {
            await setUserSubscriptionStatusResponse(
                ApiResponse.error(error.toString()));});
  }
}
