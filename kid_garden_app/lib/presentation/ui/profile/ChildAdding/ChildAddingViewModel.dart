import 'package:flutter/cupertino.dart';

import '../../../../data/network/ApiResponse.dart';
import '../../../../data/network/FromData/ChildForm.dart';
import '../../../../domain/Child.dart';
import '../../../../repos/ChildRepository.dart';

class ChildPostingViewModel extends ChangeNotifier {
  final _repository = ChildRepository();

  ApiResponse<Child> addingChildResponse = ApiResponse.non();

  void setAddingChildResponse(ApiResponse<Child> apiResponse) {
    addingChildResponse = apiResponse;
    notifyListeners();
  }

  Future<void> addChild({required ChildForm childForm}) async {
    setAddingChildResponse(ApiResponse.loading());
    _repository
        .addChild(childForm)
        .then((value) => setAddingChildResponse(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setAddingChildResponse(ApiResponse.error(error.toString())));
  }

  ChildPostingViewModel() {
    //tst();
  }

  void tst() async {

      setAddingChildResponse(ApiResponse.loading());


    await Future.delayed(Duration(milliseconds: 5000), () {
      setAddingChildResponse(ApiResponse.completed(null));
    });
  }
}
