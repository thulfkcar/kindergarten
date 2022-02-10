import 'dart:convert';

import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import 'package:kid_garden_app/network/OnCompleteListner.dart';

import '../network/BaseApiService.dart';
import '../network/NetworkApiService.dart';

class ChildRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future<List<ActionGroup>> getActionsGroups() async {
    try {
      List<ActionGroup> actionsGroups = [
        ActionGroup(
            image: "image", id: "id", date: DateTime.now(), name: "action 1"),
        ActionGroup(
            image: "image", id: "id", date: DateTime.now(), name: "action 2"),
        ActionGroup(
            image: "image", id: "id", date: DateTime.now(), name: "action 3"),
        ActionGroup(
            image: "image", id: "id", date: DateTime.now(), name: "action 4"),
        ActionGroup(
            image: "image", id: "id", date: DateTime.now(), name: "action 5"),
        ActionGroup(
            image: "image", id: "id", date: DateTime.now(), name: "action 6"),
        ActionGroup(
            image: "image", id: "id", date: DateTime.now(), name: "action 7"),
      ];

      return actionsGroups;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Child>> getMyChildList({required String userId}) async {
    try {
      // dynamic response = await _apiService.getResponse("child/${userId}");
      List<Child> childes = [];
      // childes = (json.decode(response.body) as List)
      //     .map((i) => Child.fromJson(i))
      //     .toList();

      for (int i = 0; i < 10; i++) {
        childes.add(Child(
            name: "gfgih",
            id: "nuihuihopkop",
            image:
                "https://clipart-best.com/img/simpsons/simpsons-clip-art-2.png",
            date: DateTime.now(),
            gender: Gender.Female));
      }
      return childes;
    } catch (e) {
      throw e;
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
                date: DateTime.now(),
                name: 'sdfdf',
                id: 'sdfdf',
                image:
                    'https://clipart-best.com/img/simpsons/simpsons-clip-art-2.png'),
            value: 'shaving'));
      }
      print(childActions);
      return childActions;
    } catch (e) {
      throw e;
    }
  }

  Future<ChildAction> postChildAction(
      {required ChildAction childAction}) async {
    try {
      
      childAction.actionGroup=ActionGroup(image: "https://clipart-best.com/img/simpsons/simpsons-clip-art-2.png", id: "id", date: DateTime.now(), name: "name");
      return childAction;
      
    } catch (e) {
      throw e;
    }
  }
}
