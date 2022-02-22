import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

import '../../../data/network/ApiResponse.dart';

class ChildViewModel extends ChangeNotifier {
  final _repository = ChildRepository();

  ChildViewModel() : super() {
    fetchChildren();
  }

  ApiResponse<List<Child>> childListResponse = ApiResponse.loading();

  void setChildListResponse(ApiResponse<List<Child>> response) {
    childListResponse = response;
    notifyListeners();
  }

  Future<void> fetchChildren() async {
    setChildListResponse(ApiResponse.loading());
    Future.delayed(const Duration(milliseconds: 2000), () {
      _repository
          .getMyChildList(userId: "sfdf")
          .then((value) => setChildListResponse(ApiResponse.completed(value)))
          .onError((error, stackTrace) =>
              setChildListResponse(ApiResponse.error(error.toString())));
    });
  }

  Future<void> fetchNextChildren() async {
    childListResponse.status = Status.LOADING_NEXT_PAGE;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 2000), () {
      _repository.getChildren().then((value) {
        setChildListResponse(appendNewItems(value));
      }).onError((error, stackTrace) {
        setChildListResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    });
  }

  ApiResponse<List<Child>> appendNewItems(List<Child> value) {
    var data = childListResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }
}
