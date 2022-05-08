import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';
import 'package:kid_garden_app/repos/KindergartenRepository.dart';
import 'package:tuple/tuple.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../domain/Child.dart';
import '../../../domain/ChildAction.dart';
import '../../../domain/HomeModel.dart';
import '../../../repos/ActionRepository.dart';

class HomeViewModel extends ChangeNotifier {
  final _repository = ActionRepository();
  final kindergartenRepository = KindergartenRepository();
  String? selectedActionGroupId;
  int pageChildAction = 1;
 late BuildContext _context;

  var childActionsLastPage = false;

  HomeViewModel(BuildContext context) : super() {
    _context=context;
    fetchChildActions();
  }

  ApiResponse<List<Tuple2<String, String>>> homeInfoApiResponse =
      ApiResponse.non();
  ApiResponse<List<ChildAction>> childActionResponse = ApiResponse.loading();

  void setChildActionsListResponse(ApiResponse<List<ChildAction>> response) {
    childActionResponse = response;
    notifyListeners();
  }

  void setHomeInfoApiResponse(
      ApiResponse<List<Tuple2<String, String>>> response) {
    homeInfoApiResponse = response;
    notifyListeners();
  }

  Future<void> fetchHomeInfo() async {
    setHomeInfoApiResponse(ApiResponse.loading());
    kindergartenRepository.getHome().then((value) {
      List<Tuple2<String, String>> list = [
        Tuple2(AppLocalizations.of(_context)?.getText("total_actions")??"Total Actions", value.todayActions.toString()),
        Tuple2(AppLocalizations.of(_context)?.getText("staff_count")??"Staff Count", value.staffCount.toString()),
        Tuple2(AppLocalizations.of(_context)?.getText("parents_count")??"Parents Count", value.parentCount.toString()),
        Tuple2(AppLocalizations.of(_context)?.getText("children_count")??"Children Count", value.childrenCount.toString()),
      ];

      setHomeInfoApiResponse(ApiResponse.completed(list));
    }).onError((error, stackTrace) {
      setHomeInfoApiResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchChildActions() async {
    fetchHomeInfo();
    setChildActionsListResponse(ApiResponse.loading());
    _repository
        .getAllChildActions( page: pageChildAction)
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
          .getAllChildActions( page: pageChildAction)
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
