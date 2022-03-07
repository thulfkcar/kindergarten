import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../repos/ActionRepository.dart';

class ChildActionViewModel extends ChangeNotifier {
  final _repository = ActionRepository();
  String? selectedActionGroupId;

  ChildActionViewModel() : super() {
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

    notifyListeners();
  }

  void setActionGroupResponse(ApiResponse<List<ActionGroup>> response) {
    actionGroupResponse = response;
    notifyListeners();
  }

  Future<void> fetchChildActions() async {
    setChildActionsListResponse(ApiResponse.loading());
    Future.delayed(const Duration(milliseconds: 2000), () {
      _repository
          .getChildActions(childId: "sfdf")
          .then((value) =>
              setChildActionsListResponse(ApiResponse.completed(value)))
          .onError((error, stackTrace) =>
              setChildActionsListResponse(ApiResponse.error(error.toString())));
    });
  }

  Future<void> fetchActionGroups() async {
    setActionGroupResponse(ApiResponse.loading());
    _repository
        .getActionsGroups(page: 1)
        .then((value) => setActionGroupResponse(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setActionGroupResponse(ApiResponse.error(error.toString())));
  }

  void addChildAction({required ChildAction childAction}) {
    if (childActionResponse.data != null) {
      setChildActionPostResponse(ApiResponse.loading());

      Future.delayed(const Duration(milliseconds: 2000), () {
        _repository
            .postChildAction(childAction: childAction)
            .then((value) =>
                setChildActionPostResponse(ApiResponse.completed(value)))
            .onError((error, stackTrace) => setChildActionPostResponse(
                ApiResponse.error(error.toString())));
      });
    }
  }

  Future<void> fetchNextChildActions() async {
    childActionResponse.status = Status.LOADING_NEXT_PAGE;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 2000), () {
      _repository.getChildActions(childId: "SDF").then((value) {
        setChildActionsListResponse(appendNewItems(value));
      }).onError((error, stackTrace) {
        setChildActionsListResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    });
  }

  ApiResponse<List<ChildAction>> appendNewItems(List<ChildAction> value) {
    var data = childActionResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }
}
