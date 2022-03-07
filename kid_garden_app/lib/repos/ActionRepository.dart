import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/models/MultiResponse.dart';
import '../domain/ActionGroup.dart';
import '../domain/ChildAction.dart';

class ActionRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future<List<ActionGroup>> getActionsGroups({required int page}) async {
    try {
      dynamic response =
          await _apiService.getResponse("ActionList/getAll/$page");

      var actionGroups;
      MultiResponse<List<ActionGroup>>.fromJson(await response, (jsonList) {
        if (jsonList != null) {
          actionGroups =
              (jsonList as List).map((i) => ActionGroup.fromJson(i)).toList();
          return actionGroups;
        } else {
          throw "no Data Available";
        }
      });
      if (await actionGroups.isNotEmpty) {
        return await actionGroups;
      } else {
        throw "no Data Available";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChildAction>> getChildActions({required String childId}) async {
    try {
      List<ChildAction> childActions = [];

      for (int i = 0; i < 5; i++) {
        childActions.add(ChildAction(
            id: "id",
            actionGroupId: "actionGroupId",
            actionGroup: ActionGroup(
                actionName: 'sdfdf',
                id: 'sdfdf',
                image:
                    'https://clipart-best.com/img/simpsons/simpsons-clip-art-2.png'),
            value: 'shaving'));
      }
      return childActions;
    } catch (e) {
      rethrow;
    }
  }

  Future<ChildAction> postChildAction(
      {required ChildAction childAction}) async {
    try {
      childAction.actionGroup = ActionGroup(
          image:
              "https://clipart-best.com/img/simpsons/simpsons-clip-art-2.png",
          id: "id",
          actionName: "name");
      return childAction;
    } catch (e) {
      rethrow;
    }
  }
}
