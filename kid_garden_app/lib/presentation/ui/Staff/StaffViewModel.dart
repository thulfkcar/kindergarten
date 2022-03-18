import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/data/network/FromData/AssingChildForm.dart';
import 'package:kid_garden_app/data/network/FromData/StaffAddingForm.dart';
import 'package:kid_garden_app/repos/UserRepo.dart';
import '../../../domain/Child.dart';
import '../../../domain/User.dart';

class StaffViewModel extends ChangeNotifier {
  var staffLastPage = false;
  int pageStaff = 1;

  final UserRepository _repository = UserRepository();
  ApiResponse addingStaffResponse = ApiResponse.non();
  ApiResponse<List<User>> childListResponse = ApiResponse.loading();

  void setStaffListResponse(ApiResponse<List<User>> response) {
    childListResponse = response;

    notifyListeners();
  }
  void setAddingStaffResponseApi(ApiResponse response) {
    addingStaffResponse = response;
    notifyListeners();
  }


  StaffViewModel():super(){
    fetchStaff();
  }

  Future<void> addStaff({required StaffAddingForm staffAddingForm}) async {
    setAddingStaffResponseApi(ApiResponse.loading());
    _repository
        .adduser(staffAddingForm: staffAddingForm)
        .then((value) {
          setAddingStaffResponseApi(ApiResponse.completed(value));
    })
        .onError((error, stackTrace) {setAddingStaffResponseApi(ApiResponse.error(error.toString()));});
  }



  Future<void> fetchStaff() async {
    setStaffListResponse(ApiResponse.loading());
    _repository.getMyStaffList(page: pageStaff).then((value) {
      staffLastPage = value.item2;
      setStaffListResponse(ApiResponse.completed(value.item1));
    }).onError((error, stackTrace) {
      setStaffListResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextStaff() async {
    if (staffLastPage == false) {
      incrementPageChildAction();
      childListResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository.getMyStaffList(page: pageStaff).then((value) {
        staffLastPage = value.item2;
        setStaffListResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setStaffListResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }

  void incrementPageChildAction() {
    pageStaff += 1;
  }

  ApiResponse<List<User>> appendNewItems(List<User> value) {
    var data = childListResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }

  assignChild({required AssignChildForm staffAddingForm}) {}
}
