import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

import '../../../data/network/ApiResponse.dart';

class ChildViewModel extends ChangeNotifier {
  final _repository = ChildRepository();

  ChildViewModel() : super() {
    fetchChilds();
  }

  ApiResponse<List<Child>> childListResponse = ApiResponse.loading();

  void setChildListResponse(ApiResponse<List<Child>> response) {
    print("thug :: $response");
    childListResponse = response;
    notifyListeners();
  }

  Future<void> fetchChilds() async {
    setChildListResponse(ApiResponse.loading());
    _repository
        .getMyChildList(userId: "sfdf")
        .then((value) => setChildListResponse(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setChildListResponse(ApiResponse.error(error.toString())));
  }
}
