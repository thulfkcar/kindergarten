import 'package:flutter/cupertino.dart';
import '../../../../data/network/ApiResponse.dart';
import '../../../../domain/AssignRequest.dart';
import '../../../../repos/UserRepo.dart';

class ChildProfileViewModel extends ChangeNotifier{
  final _userRepository = UserRepository();
  ApiResponse<AssignRequest> joinKindergartenRequest = ApiResponse.non();

  Future<void> joinRequest(String childId,String kindergartenId) async {
    //after request done
      await setJoinKindergartenRequest(ApiResponse.loading());
      await _userRepository
          .requestToKindergarten(childId, kindergartenId)
          .then((value) async {
        await setJoinKindergartenRequest(ApiResponse.completed(value));
      }).onError((error, stackTrace) async {
        await setJoinKindergartenRequest(ApiResponse.error(error.toString()));
      });

  }



  Future<void> setJoinKindergartenRequest(
      ApiResponse<AssignRequest> response) async {
    joinKindergartenRequest = response;
    notifyListeners();
  }




}