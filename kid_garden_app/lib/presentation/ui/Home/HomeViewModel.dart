import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../domain/Child.dart';
import '../../../providers/Providers.dart';

class HomeViewModel extends ChangeNotifier {
  final childRepo = ChildRepository();
  ApiResponse<List<Child>> childActivitiesApiResponse = ApiResponse.loading();

  void setChildActivitiesApiResponse(ApiResponse<List<Child>> response) {
    childActivitiesApiResponse = response;
    notifyListeners();
  }
  Future<void> fetchChildrenWithInfo() async {
    setChildActivitiesApiResponse(ApiResponse.loading());
    childRepo
        .getChildrenWithInfo()
        .then((value) =>
            setChildActivitiesApiResponse(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setChildActivitiesApiResponse(ApiResponse.error(error.toString())));
  }

  HomeViewModel() : super() {
    fetchChildrenWithInfo();
  }

  Future<void> fetchNextChildrenWithInfo() async {
    childActivitiesApiResponse.status = Status.LOADING_NEXT_PAGE;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 2000), () {
      childRepo.getChildrenWithInfo().then((value) {
      setChildActivitiesApiResponse(appendNewItems(value));
    }).onError((error, stackTrace) {
      setChildActivitiesApiResponse(ApiResponse.error(error.toString()));
    });
      notifyListeners();
    });
  }

  ApiResponse<List<Child>> appendNewItems(List<Child> value) {
    var data = childActivitiesApiResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }
}
