import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/network/ApiResponse.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

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
}
