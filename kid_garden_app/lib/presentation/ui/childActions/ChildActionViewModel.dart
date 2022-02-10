import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';
import '../../../network/ApiResponse.dart';

class ChildActionViewModel extends ChangeNotifier {
  var childActionRepo = ChildRepository();
  String? selectedActionGroupId;

  setSelectedActionGroupId(String id) {
    selectedActionGroupId = id;
  }

  ApiResponse<List<ChildAction>> childActionResponse = ApiResponse.loading();
  ApiResponse<List<ActionGroup>> actionGroupResponse = ApiResponse.loading();
  ApiResponse<ChildAction> childActionPostResponse = ApiResponse.loading();

  void setChildActionsListResponse(ApiResponse<List<ChildAction>> response) {
    print("thug :: child actions $response");
    childActionResponse = response;
    notifyListeners();
  }

  void setChildActionPostResponse(ApiResponse<ChildAction> response) {
    print("thug :: child actions $response");
    childActionPostResponse = response;
    if (response.status == Status.COMPLETED) {
      childActionResponse.data!.add(response.data!);
    }
    notifyListeners();
  }

  void setActionGroupResponse(ApiResponse<List<ActionGroup>> response) {
    print("thug :: action groups $response");
    actionGroupResponse = response;
    notifyListeners();
  }

  Future<void> fetchChildActions() async {
    setChildActionsListResponse(ApiResponse.loading());
    childActionRepo
        .getChildActions(childId: "sfdf")
        .then((value) =>
            setChildActionsListResponse(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setChildActionsListResponse(ApiResponse.error(error.toString())));
  }

  Future<void> fetchActionGroups() async {
    setActionGroupResponse(ApiResponse.loading());
    childActionRepo
        .getActionsGroups()
        .then((value) => setActionGroupResponse(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setActionGroupResponse(ApiResponse.error(error.toString())));
  }

  void addChildAction({required ChildAction childAction}) {
    if (childActionResponse.data != null) {
      setChildActionPostResponse(ApiResponse.loading());
      childActionRepo
          .postChildAction(childAction: childAction)
          .then((value) =>
              setChildActionPostResponse(ApiResponse.completed(value)))
          .onError((error, stackTrace) =>
              setChildActionPostResponse(ApiResponse.error(error.toString())));
    }
  }
}
