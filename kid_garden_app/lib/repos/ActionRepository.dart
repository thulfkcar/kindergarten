import 'dart:io';

import 'package:kid_garden_app/data/network/models/ErrorResponse.dart';
import 'package:kid_garden_app/domain/HomeModel.dart';

import '../data/network/BaseApiService.dart';
import '../data/network/NetworkApiService.dart';
import '../data/network/models/MultiResponse.dart';
import '../data/network/models/SingleResponse.dart';
import '../domain/ActionGroup.dart';
import '../domain/ChildAction.dart';
import 'package:tuple/tuple.dart';

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

  Future<Tuple2<List<ChildAction>, bool>> getChildActions(
      {required String? childId, required int page}) async {
    try {
      dynamic response = await _apiService
          .getResponse("ChildAction/getAll/$page?ChildId=$childId");

      bool isLastPage = false;
      List<ChildAction> childActions = [];
      var mainResponse =
          MultiResponse<List<ChildAction>>.fromJson(await response, (jsonList) {
        if (jsonList != null) {
          childActions =
              (jsonList as List).map((i) => ChildAction.fromJson(i)).toList();
          return childActions;
        } else {
          throw "no Data Available";
        }
      });
      var nextPageTotal = (page) * 20;
      if (nextPageTotal >= (mainResponse.count)) {
        isLastPage = true;
      }

      if (await childActions.isNotEmpty) {
        return Tuple2(await childActions, isLastPage);
      } else {
        throw "no Data Available";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Tuple2<List<ChildAction>, bool>> getAllChildActions(
      {required int page}) async {
    try {
      dynamic response = await _apiService
          .getResponse("Kindergarten/getAllChildActions/$page");

      bool isLastPage = false;
      List<ChildAction> childActions = [];
      var mainResponse =
          MultiResponse<List<ChildAction>>.fromJson(await response, (jsonList) {
        if (jsonList != null) {
          childActions =
              (jsonList as List).map((i) => ChildAction.fromJson(i)).toList();
          return childActions;
        } else {
          throw "no Data Available";
        }
      });
      var nextPageTotal = (page) * 20;
      if (nextPageTotal >= (mainResponse.count)) {
        isLastPage = true;
      }

      if (await childActions.isNotEmpty) {
        return Tuple2(await childActions, isLastPage);
      } else {
        throw "no Data Available";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ChildAction> postChildAction(
      {required ChildAction childAction, List<File>? assets}) async {
    try {
      Map<String, String> jsonBody = {};
      jsonBody.addAll({
        "ChildId": childAction.childId,
        "ActionListId": childAction.actionGroupId,
        "Value": childAction.value,
        "Audience": childAction.audience.index.toString()
      });

      dynamic response = await _apiService.multiPartPostResponse(
          "ChildAction/add", jsonBody, assets);
      var data;

      SingleResponse<ChildAction>.fromJson(await response, (json) {
        data = ChildAction.fromJson(json as Map<String, dynamic>);
        return data;
      });
      return await data;

      return childAction;
    } catch (e) {
      if (e is ErrorResponse) {
        throw e.errorMsg.toString();
      }
      rethrow;
    }
  }


}
