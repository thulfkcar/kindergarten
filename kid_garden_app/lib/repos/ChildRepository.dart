import 'dart:convert';

import 'package:kid_garden_app/data/network/models/MultiResponse.dart';
import 'package:kid_garden_app/data/network/models/SingleResponse.dart';
import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import 'package:kid_garden_app/domain/User.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/models/LoginRequestData.dart';

class ChildRepository {
  ChildRepository();

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
      dynamic response = await _apiService.getResponse("Child/getAll/1");

      List<Child> childes;

      var object = MultiResponse.fromJson(response).data;
      var jsonObject = json.decode(object!) as List;
      childes = (jsonObject).map((i) => Child.fromJson(i)).toList();

      return childes;
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
                date: DateTime.now(),
                name: 'sdfdf',
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
          date: DateTime.now(),
          name: "name");
      return childAction;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Child>> getChildrenWithInfo() async {
    try {
      List<Child> children = [];

      children.add(Child(
          name: "name",
          id: "asdfaf",
          image:
              "https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png",
          childActions: [
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
          ]));
      children.add(Child(
          name: "name",
          id: "asdfaf",
          image:
              "https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png",
          childActions: [
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
          ]));
      children.add(Child(
          name: "name",
          id: "asdfaf",
          image:
              "https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png",
          childActions: [
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
          ]));
      children.add(Child(
          name: "name",
          id: "asdfaf",
          image:
              "https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png",
          childActions: [
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    date: DateTime.now(),
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    name: 'gsdfgsfg')),
          ]));

      return children;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> auth(
      {required String userName, required String password}) async {
    try {
      dynamic response = await _apiService.postResponseJsonBody(
          "User/login", "{email: '$userName', password: '$password'}");

      var user;
        SingleResponse<User>.fromJson(
          await response,  (json)   {
             user=   User.fromJson(json as Map<String, dynamic>);
            return user;
          });
      return await user;


    } catch (e) {
      rethrow;
    }
  }

  Future<List<Child>> getChildren() async {
    return await getMyChildList(userId: "fdg");
  }
}
