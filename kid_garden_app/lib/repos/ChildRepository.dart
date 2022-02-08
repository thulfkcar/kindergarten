import 'package:kid_garden_app/domain/Action.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import 'package:kid_garden_app/network/OnCompleteListner.dart';

class ChildRepository {
  Future<void> addChildAction(
      {required ChildAction childAction, required OnCompleteListener onCompleteListener}) async {
    onCompleteListener.onCompleted(childAction);
  }

  Future<void> getActionsGroups(
      {required OnCompleteListener onCompleteListener}) async {
    List<ActionGroup> actionsGroups = [
      ActionGroup(image: "image", id: "id", date: DateTime.now(), name: "action 1"),
      ActionGroup(image: "image", id: "id", date: DateTime.now(), name: "action 2"),
      ActionGroup(image: "image", id: "id", date: DateTime.now(), name: "action 3"),
      ActionGroup(image: "image", id: "id", date: DateTime.now(), name: "action 4"),
    ];
    onCompleteListener.onCompleted(
        actionsGroups

    );
  }
}
