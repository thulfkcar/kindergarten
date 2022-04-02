import 'package:flutter/material.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import '../../../domain/UserModel.dart';
import '../../../repos/UserRepo.dart';

class ParentViewModel extends ChangeNotifier{
  ApiResponse<List<UserModel>> parentListResponse=ApiResponse.non();





  final _repository = UserRepository();
  var parentsLastPage = false;
  int pageParents = 1;

  String? searchKey;

  ParentViewModel() : super() {
    fetchParents();


  }

 void setParentsListResponse(ApiResponse<List<UserModel>> response){
    parentListResponse=response;
    notifyListeners();
  }

  Future<void> fetchParents() async {
    setParentsListResponse(ApiResponse.loading());
    _repository.getMyParentsList(page: pageParents,searchKey:searchKey).then((value) {
      parentsLastPage = value.item2;
      setParentsListResponse(ApiResponse.completed(value.item1));
    }).onError((error, stackTrace) {
      setParentsListResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextParents() async {
    if (parentsLastPage == false) {
      incrementPage();
      parentListResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository.getMyParentsList(page: pageParents,searchKey: searchKey).then((value) {
        parentsLastPage = value.item2;
        setParentsListResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setParentsListResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }
  void incrementPage() {
    pageParents += 1;
  }

  ApiResponse<List<UserModel>> appendNewItems(List<UserModel> value) {
    var data = parentListResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }

  void search(String? value) {
    searchKey=value;
    fetchParents();
  }

}