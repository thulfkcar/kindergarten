import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../domain/Child.dart';
import '../../../domain/ChildAction.dart';
import '../../../repos/ActionRepository.dart';

class HomeViewModel extends ChangeNotifier {
  final _repository = ActionRepository();
  String? selectedActionGroupId;
  int pageChildAction = 1;

  var childActionsLastPage = false;
  HomeViewModel() : super() {
    fetchChildActions();

  }

  ApiResponse<List<Child>> childActivitiesApiResponse = ApiResponse.loading();
  ApiResponse<List<ChildAction>> childActionResponse = ApiResponse.loading();
  void setChildActionsListResponse(ApiResponse<List<ChildAction>> response) {
    childActionResponse = response;
    notifyListeners();
  }
  void setChildListResponse(ApiResponse<List<Child>> response) {
    childActivitiesApiResponse = response;
    notifyListeners();
  }

  Future<void> fetchChildActions() async {
    setChildActionsListResponse(ApiResponse.loading());
    _repository
        .getChildActions(childId: null, page: pageChildAction)
        .then((value) {
      childActionsLastPage = value.item2;
      setChildActionsListResponse(ApiResponse.completed(value.item1));
    }).onError((error, stackTrace) {
      setChildActionsListResponse(ApiResponse.error(error.toString()));
    });
  }
  Future<void> fetchNextChildActions() async {
    if (childActionsLastPage == false) {
      incrementPageChildAction();
      childActionResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository
          .getChildActions(childId: null, page: pageChildAction)
          .then((value) {
        childActionsLastPage = value.item2;
        setChildActionsListResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setChildActionsListResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }

  void incrementPageChildAction() {
    pageChildAction += 1;
  }

  ApiResponse<List<ChildAction>> appendNewItems(List<ChildAction> value) {
    var data = childActionResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }

}
