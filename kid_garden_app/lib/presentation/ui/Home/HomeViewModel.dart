import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../domain/Child.dart';

class HomeViewModel extends ChangeNotifier {
  final _repository = ChildRepository();
  var childActionsLastPage = false;
  int pageChildAction = 1;

  HomeViewModel() : super() {
    fetchChildren();
  }

  ApiResponse<List<Child>> childActivitiesApiResponse = ApiResponse.loading();

  void setChildListResponse(ApiResponse<List<Child>> response) {
    childActivitiesApiResponse = response;
    notifyListeners();
  }

  Future<void> fetchChildren() async {
    setChildListResponse(ApiResponse.loading());
    _repository.getMyChildList(page:pageChildAction).then((value) {
      childActionsLastPage = value.item2;
      setChildListResponse(ApiResponse.completed(value.item1));
    }).onError((error, stackTrace) {
      setChildListResponse(ApiResponse.error(error.toString()));
    });
  }


  Future<void> fetchNextChildrenWithInfo() async {
    if (childActionsLastPage == false) {
      incrementPageChildAction();
      childActivitiesApiResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository
          .getMyChildList( page: pageChildAction)
          .then((value) {
        childActionsLastPage = value.item2;
        setChildListResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setChildListResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }
  void incrementPageChildAction() {
    pageChildAction += 1;
  }
  ApiResponse<List<Child>> appendNewItems(List<Child> value) {
    var data = childActivitiesApiResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }
}
