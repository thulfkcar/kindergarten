import 'package:flutter/cupertino.dart';
import '../../../../data/network/ApiResponse.dart';
import '../../../../domain/AssignRequest.dart';
import '../../../../repos/UserRepo.dart';

class ChildProfileViewModel extends ChangeNotifier {
  final _userRepository = UserRepository();
  ApiResponse<AssignRequest> joinKindergartenRequest = ApiResponse.non();
  ApiResponse<bool> cancelJoinRequestResponse = ApiResponse.non();

  Future<void> joinRequest(String childId, String kindergartenId) async {
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

  Future<void> setCancelJoinRequestResponse(
      ApiResponse<bool> response) async {
    cancelJoinRequestResponse = response;
    notifyListeners();
  }

  Future<void> cancelJoinRequest(String joinRequestId) async {
    await setCancelJoinRequestResponse(ApiResponse.loading());
    await _userRepository.cancelJoinRequest(joinRequestId).then((value) {
      setCancelJoinRequestResponse(ApiResponse.completed(value)).then((value) {
        joinKindergartenRequest.data=null;
        notifyListeners();
      });

    }).onError((error, stackTrace) {
      setCancelJoinRequestResponse(ApiResponse.error(error.toString()));
    });
  }
}
