import 'package:flutter/cupertino.dart';

import '../../../../data/network/ApiResponse.dart';
import '../../../../domain/AssignRequest.dart';
import '../../../../repos/UserRepo.dart';

class ChildProfileViewModel extends ChangeNotifier{
  String? requestedKindergartenId;
  final _userRepository = UserRepository();
  ApiResponse<AssignRequest> joinKindergartenRequest = ApiResponse.non();

  Future<void> joinRequest(String childId) async {
    //after request done
    if (requestedKindergartenId != null) {
      await setJoinKindergartenRequest(ApiResponse.loading());
      await _userRepository
          .requestToKindergarten(childId, requestedKindergartenId!)
          .then((value) async {
        await setJoinKindergartenRequest(ApiResponse.completed(value));
        setRequestedKindergartenId(null);
      }).onError((error, stackTrace) async {
        await setJoinKindergartenRequest(ApiResponse.error(error.toString()));
        setRequestedKindergartenId(null);
      });
    }
  }

  Future<void> setJoinKindergartenRequest(
      ApiResponse<AssignRequest> response) async {
    joinKindergartenRequest = response;
    notifyListeners();
  }

  void setRequestedKindergartenId(String? id) {
    requestedKindergartenId = id;
  }
}