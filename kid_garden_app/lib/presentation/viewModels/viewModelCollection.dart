import 'package:flutter/cupertino.dart';

import '../../data/network/ApiResponse.dart';

class ViewModelCollection<T> extends ChangeNotifier {
  var lastPage = false;
  int page = 1;

  ApiResponse<List<T>> collectionApiResponse = ApiResponse.non();


  void setCollectionApiResponse(ApiResponse<List<T>> response) {
    collectionApiResponse = response;
    if(response.data!=null ) {
      if(response.data!.isEmpty) {
        collectionApiResponse=ApiResponse.empty();
      }
    }

    notifyListeners();
  }
  void incrementPageChildAction() {
    page += 1;
  }

  ApiResponse<List<T>> appendNewItems(List<T> value) {
    var data = collectionApiResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }
  void addNewItemToCollection(T value) {
    var data = collectionApiResponse.data;
    data?.add(value);
    notifyListeners();
  }



}
