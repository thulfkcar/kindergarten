import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/data/network/FromData/AssingChildForm.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

class AssignChildViewModel extends ChangeNotifier {
  String? childId;
  final _repository = ChildRepository();
  ApiResponse assigningChildResponse = ApiResponse.non();

  AssignChildViewModel({this.childId}) : super();

  Future<void> assignChild(String StaffId) async {
    setAssigningChildResponse(ApiResponse.loading());
    var assignForm = AssignChildForm();
    assignForm.staffId = StaffId;
    assignForm.childID = this.childId;
    _repository
        .assignChild(assignForm)
        .then(
            (value) => setAssigningChildResponse(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setAssigningChildResponse(ApiResponse.error(error.toString())));
  }

  void setAssigningChildResponse(ApiResponse<dynamic> apiResponse) {
    assigningChildResponse = apiResponse;

    notifyListeners();
  }
}
