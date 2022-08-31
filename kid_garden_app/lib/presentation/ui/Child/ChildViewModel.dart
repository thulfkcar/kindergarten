import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/presentation/viewModels/viewModelCollection.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../data/network/FromData/ChildForm.dart';

class ChildViewModel extends ViewModelCollection<Child> {
  final _repository = ChildRepository();
  String? subUserId;

  String? searchKey;

  ChildViewModel({required this.subUserId}) : super() {
    fetchChildren();
  }



  ApiResponse<Child> addingChildResponse = ApiResponse.non();

  void setAddingChildResponse(ApiResponse<Child> apiResponse) {
    addingChildResponse = apiResponse;


      notifyListeners();
  }
  Future<void> addChild({required ChildForm childForm}) async {
    setAddingChildResponse(ApiResponse.loading());
    _repository.addChild( childForm).then((value) {
      addNewItemToCollection(value);
      setAddingChildResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setAddingChildResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchChildren() async {
    setCollectionApiResponse(ApiResponse.loading());
    _repository.getMyChildList(page: page,searchKey:searchKey,subUserId: subUserId).then((value) {
      lastPage = value.item2;
      if(value.item1.isEmpty){
        setCollectionApiResponse(ApiResponse.empty());
      }
      setCollectionApiResponse(ApiResponse.completed(value.item1));
    }).onError((error, stackTrace) {
      setCollectionApiResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextChildren() async {
    if (lastPage == false) {
      incrementPage();
      collectionApiResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository.getMyChildList(page: page,searchKey: searchKey,subUserId: subUserId).then((value) {
        lastPage = value.item2;
        setCollectionApiResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setCollectionApiResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }





  void search(String? value) {
    this.searchKey=value;
    fetchChildren();
  }
}
