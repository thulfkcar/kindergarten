
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/data/network/FromData/AssingChildForm.dart';
import 'package:kid_garden_app/data/network/FromData/StaffAddingForm.dart';
import 'package:kid_garden_app/repos/UserRepo.dart';
import '../../../../../domain/UserModel.dart';
import '../../../../viewModels/viewModelCollection.dart';

class StaffViewModel extends ViewModelCollection<UserModel> {

  final UserRepository _repository = UserRepository();
  ApiResponse addingStaffResponse = ApiResponse.non();



  void setAddingStaffResponseApi(ApiResponse response) {

    addingStaffResponse = response;
    notifyListeners();
  }

  StaffViewModel() : super() {
    fetchStaff();
  }

  Future<void> addStaff({required StaffAddingForm staffAddingForm}) async {
    setAddingStaffResponseApi(ApiResponse.loading());
    _repository.addStaff(staffAddingForm: staffAddingForm).then((value) {
      setAddingStaffResponseApi(ApiResponse.completed(value));
      addNewItemToCollection(value);

    }).onError((error, stackTrace) {
      setAddingStaffResponseApi(ApiResponse.error(error.toString()));
    });
  }




  Future<void> fetchStaff() async {
    setCollectionApiResponse(ApiResponse.loading());
    _repository.getMyStaffList(page: page).then((value) {
      lastPage = value.item2;
      if(value.item1.isEmpty){
        setCollectionApiResponse(ApiResponse.empty());
      }else {
        setCollectionApiResponse(ApiResponse.completed(value.item1));
      }

    }).onError((error, stackTrace) {
      setCollectionApiResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextStaff() async {
    if (page == false) {
      incrementPage();
      collectionApiResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository.getMyStaffList(page: page).then((value) {
        lastPage = value.item2;
        setCollectionApiResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setCollectionApiResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }




  assignChild({required AssignChildForm staffAddingForm}) {}
}
