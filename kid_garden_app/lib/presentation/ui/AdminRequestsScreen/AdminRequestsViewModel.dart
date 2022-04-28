import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/AssignRequest.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../repos/UserRepo.dart';

class AdminRequestsViewModel extends ChangeNotifier {
  var staffLastPage = false;
  int pageStaff = 1;

  final UserRepository _repository = UserRepository();
  ApiResponse<List<AssignRequest>> adminRequestsResponse =
      ApiResponse.loading();
  ApiResponse<AssignRequest> acceptResponse = ApiResponse.non();
  ApiResponse<AssignRequest> rejectResponse = ApiResponse.non();

  void setAdminRequestsResponse(ApiResponse<List<AssignRequest>> response) {
    adminRequestsResponse = response;

    notifyListeners();
  }

  Future<void> setAcceptResponse(ApiResponse<AssignRequest> response) async {
    acceptResponse = response;
    if (response.data != null) await updateList(response.data!);
    notifyListeners();
  }

  Future<void> setRejectResponse(ApiResponse<AssignRequest> response) async {
    rejectResponse = response;
    if (response.data != null)  await updateList(response.data!);

    notifyListeners();
  }

  AdminRequestsViewModel() : super() {
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    setAdminRequestsResponse(ApiResponse.loading());
    _repository.getAdminRequests(page: pageStaff).then((value) {
      staffLastPage = value.item2;
      setAdminRequestsResponse(ApiResponse.completed(value.item1));
    }).onError((error, stackTrace) {
      setAdminRequestsResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextRequests() async {
    if (staffLastPage == false) {
      incrementPageChildAction();
      adminRequestsResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository.getAdminRequests(page: pageStaff).then((value) {
        staffLastPage = value.item2;
        setAdminRequestsResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setAdminRequestsResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }

  void incrementPageChildAction() {
    pageStaff += 1;
  }

  ApiResponse<List<AssignRequest>> appendNewItems(List<AssignRequest> value) {
    var data = adminRequestsResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }

  Future<void> reject(String id, String message) async {
    await setRejectResponse(ApiResponse.loading());
    await _repository.rejectRequest(id, message).then((value) async {
      await setRejectResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) async {
      setRejectResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> accept(String id) async {
    await setAcceptResponse(ApiResponse.loading());
    await _repository.acceptRequest(id).then((value) async {
      await setAcceptResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) async {
      await setAcceptResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> updateList(AssignRequest request) async {
    if (adminRequestsResponse.data != null) {
      int index = adminRequestsResponse.data!
          .indexWhere((element) => element.id == request.id);
      if (index >= 0) {
        adminRequestsResponse.data!.removeAt(index);
        adminRequestsResponse.data!.insert(index, request);
      }
    }
    notifyListeners();
  }
}
