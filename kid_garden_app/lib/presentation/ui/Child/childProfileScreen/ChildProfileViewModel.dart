import 'package:flutter/cupertino.dart';
import '../../../../data/network/ApiResponse.dart';
import '../../../../domain/AssignRequest.dart';
import '../../../../repos/UserRepo.dart';

class ChildProfileViewModel extends ChangeNotifier {
  final _userRepository = UserRepository();
  ApiResponse<AssignRequest> joinKindergartenRequest = ApiResponse.non();
  ApiResponse<bool> cancelJoinRequestResponse = ApiResponse.non();
  ApiResponse<bool> leaveKindergartenResponse = ApiResponse.non();
  ApiResponse<bool> removeChildResponse = ApiResponse.non();

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

  Future<void> setCancelJoinRequestResponse(ApiResponse<bool> response) async {
    cancelJoinRequestResponse = response;
    notifyListeners();
  }

  Future<void> setLeaveKindergartenResponse(ApiResponse<bool> response) async {
    leaveKindergartenResponse = response;
    notifyListeners();
  }

  Future<void> setRemoveChildResponse(ApiResponse<bool> response) async {
    removeChildResponse = response;
    notifyListeners();
  }

  Future<void> cancelJoinRequest(String joinRequestId) async {
    await setCancelJoinRequestResponse(ApiResponse.loading());
    await _userRepository.cancelJoinRequest(joinRequestId).then((value) {
      setCancelJoinRequestResponse(ApiResponse.completed(value)).then((value) {
        joinKindergartenRequest.data = null;
        notifyListeners();
      });
    }).onError((error, stackTrace) {
      setCancelJoinRequestResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> removeChildFromKindergarten(String id) async {
    await setRemoveChildResponse(ApiResponse.loading());

    await _userRepository.removeChildFromKindergarten(id).then((value) {
      setRemoveChildResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setRemoveChildResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> leaveKindergarten(String id) async {
    await setLeaveKindergartenResponse(ApiResponse.loading());
    await _userRepository.leaveKindergarten(id).then((value) {
      setLeaveKindergartenResponse(ApiResponse.completed(value)).then((value) {
        joinKindergartenRequest.data = null;
        notifyListeners();
      });
    }).onError((error, stackTrace) {
      setLeaveKindergartenResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> removeChildEntirely(String id) async {
    await setRemoveChildResponse(ApiResponse.loading());
    await _userRepository.removeChildEntirely(id).then((value) {
      setRemoveChildResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setRemoveChildResponse(ApiResponse.error(error.toString()));
    });
  }
}
