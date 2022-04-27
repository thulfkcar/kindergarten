import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/AssignRequest.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../repos/UserRepo.dart';

class AdminRequestsViewModel extends ChangeNotifier{

  var staffLastPage = false;
  int pageStaff = 1;

  final UserRepository _repository = UserRepository();
  ApiResponse<List<AssignRequest>> adminRequestsResponse = ApiResponse.loading();

  void setAdminRequestsResponse(ApiResponse<List<AssignRequest>> response) {
    adminRequestsResponse = response;

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



}