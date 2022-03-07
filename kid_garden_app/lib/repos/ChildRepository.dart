
import '../data/network/models/MultiResponse.dart';
import 'package:kid_garden_app/data/network/models/SingleResponse.dart';
import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import 'package:kid_garden_app/domain/User.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';

class ChildRepository {
  ChildRepository();

  final BaseApiService _apiService = NetworkApiService();
  Future<List<Child>> getMyChildList() async {
    try {
      dynamic response = await _apiService.getResponse("Child/getAll/1");

      var childes;
      MultiResponse<List<Child>>.fromJson(await response, (jsonList) {
        if (jsonList != null) {
          childes = (jsonList as List).map((i) => Child.fromJson(i)).toList();
          return childes;
        } else {
          throw "no Data Available";
        }
      });
      if (await childes.isNotEmpty) {
        return await childes;
      } else {
        throw "no Data Available";
      }
      // var jsonObject = json.decode(object!) as List;
      // childes = (jsonObject).map((i) => Child.fromJson(i)).toList();
    } catch (e) {
      rethrow;
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
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
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
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
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
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
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
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
            ChildAction(
                id: "id",
                actionGroupId: "actionGroupId",
                value: "asdfdasfdfdf",
                actionGroup: ActionGroup(
                    id: '',
                    image:
                        'https://png.pngtree.com/png-clipart/20180626/ourmid/pngtree-instagram-icon-instagram-logo-png-image_3584853.png',
                    actionName: 'gsdfgsfg')),
          ]));

      return children;
    } catch (e) {
      rethrow;
    }
  }
  Future<User?> auth({required String userName, required String password}) async {
    try {
      dynamic response = await _apiService.postResponseJsonBody(
          "User/login", "{email: '$userName', password: '$password'}");
      var user;
      SingleResponse<User>.fromJson(await response, (json) {
        user = User.fromJson(json as Map<String, dynamic>);
        return user;
      });
      return await user;
    } catch (e) {
      rethrow;
    }
  }
  Future<List<Child>> getChildren() async {
    return await getMyChildList();
  }

}
