import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

import '../../../../../data/network/ApiResponse.dart';
import '../../../../../data/network/FromData/ChildForm.dart';


class ParentChildrenViewModel extends ChangeNotifier {
  final _repository = ChildRepository();
  var childLastPage = false;
  int pageChild = 1;

  String? searchKey;

  ParentChildrenViewModel() : super() {
    fetchChildren();
  }

  ApiResponse<List<Child>> childListResponse = ApiResponse.loading();

  void setChildListResponse(ApiResponse<List<Child>> response) {
    childListResponse = response;

    notifyListeners();
  }

  ApiResponse<Child> addingChildResponse = ApiResponse.non();

  void setAddingChildResponse(ApiResponse<Child> apiResponse) {
    addingChildResponse = apiResponse;
    if (apiResponse.data != null) {
      setChildListResponse(appendNewItems([apiResponse.data!]));
    }

    notifyListeners();
  }

  Future<void> addChild({required ChildForm childForm}) async {
    setAddingChildResponse(ApiResponse.loading());
    _repository.addChild(childForm).then((value) {
      childListResponse.data ??= [];
      setAddingChildResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setAddingChildResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchChildren() async {
    setChildListResponse(ApiResponse.loading());
    _repository
        .getMyChildList(page: pageChild, searchKey: searchKey, subUserId: null)
        .then((value) {
      childLastPage = value.item2;
      setChildListResponse(ApiResponse.completed(value.item1));
    }).onError((error, stackTrace) {
      setChildListResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextChildren() async {
    if (childLastPage == false) {
      incrementPageChildAction();
      childListResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository
          .getMyChildList(
              page: pageChild, searchKey: searchKey, subUserId: null)
          .then((value) {
        childLastPage = value.item2;
        setChildListResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setChildListResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }

  void incrementPageChildAction() {
    pageChild += 1;
  }

  ApiResponse<List<Child>> appendNewItems(List<Child> value) {
    var data = childListResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }

  void search(String? value) {
    this.searchKey = value;
    fetchChildren();
  }
}
