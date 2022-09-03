import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../repos/ActionRepository.dart';

class ChildActionViewModel extends ChangeNotifier {
  final _repository = ActionRepository();
  String? selectedActionGroupId;
  int pageChildAction = 1;
  String? childId;

  var childActionsLastPage = false;

  ChildActionViewModel({required this.childId}) : super() {
    fetchActionGroups();
    fetchChildActions();
  }

  setSelectedActionGroupId(String id) {
    selectedActionGroupId = id;
  }

  ApiResponse<List<ChildAction>> childActionResponse = ApiResponse.loading();
  ApiResponse<List<ActionGroup>> actionGroupResponse = ApiResponse.loading();
  ApiResponse<ChildAction> childActionPostResponse = ApiResponse.non();

  void setChildActionsListResponse(ApiResponse<List<ChildAction>> response) {
    childActionResponse = response;
    notifyListeners();
  }

  void setChildActionPostResponse(ApiResponse<ChildAction> response) {
    childActionPostResponse = response;
    if(response.data!=null) {

      setChildActionsListResponse(appendNewItems([response.data!]));
    }
    notifyListeners();
  }

  void setActionGroupResponse(ApiResponse<List<ActionGroup>> response) {
    actionGroupResponse = response;
    notifyListeners();
  }

  Future<void> fetchChildActions() async {
    setChildActionsListResponse(ApiResponse.loading());
    _repository
        .getChildActions(childId: childId!, page: pageChildAction)
        .then((value) {
      childActionsLastPage = value.item2;
      if(value.item1.isEmpty){
        setChildActionsListResponse(ApiResponse.empty());
      }
      else {
        setChildActionsListResponse(ApiResponse.completed(value.item1));
      }
    }).onError((error, stackTrace) {
      setChildActionsListResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchActionGroups() async {
    setActionGroupResponse(ApiResponse.loading());
    _repository
        .getActionsGroups(page: 1)
        .then((value) {
          setActionGroupResponse(ApiResponse.completed(value));
          if(value.isEmpty) {
            setActionGroupResponse(ApiResponse.empty());
          }
        })
        .onError((error, stackTrace) {
          setActionGroupResponse(ApiResponse.error(error.toString()));
        });
  }

  Future<void> addChildAction(
      {required ChildAction childAction, List<File>? assets}) async {
    setChildActionPostResponse(ApiResponse.loading());

    _repository
        .postChildAction(childAction: childAction, assets: assets)
        .then((value) {
      childActionResponse.data ??= [];

      return setChildActionPostResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setChildActionPostResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextChildActions() async {
    if (childActionsLastPage == false) {
      incrementPageChildAction();
      childActionResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository
          .getChildActions(childId: childId!, page: pageChildAction)
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

  void setChildId(String id) {
    childId = id;
  }

  ApiResponse<List<ChildAction>> appendNewItems(List<ChildAction> value) {
    var data = childActionResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }
}
