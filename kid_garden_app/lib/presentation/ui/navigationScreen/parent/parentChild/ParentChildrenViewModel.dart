import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/AssignRequest.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';
import 'package:kid_garden_app/repos/UserRepo.dart';
import '../../../../../data/network/ApiResponse.dart';
import '../../../../../data/network/FromData/ChildForm.dart';

class ParentChildrenViewModel extends ChangeNotifier {
  final _repository = ChildRepository();
  final _userRepository = UserRepository();
  var childLastPage = false;
  int pageChild = 1;

  String? searchKey;

  String? requestedKindergartenId;

  ParentChildrenViewModel() : super() {
    fetchChildren();
  }

  ApiResponse<List<Child>> childListResponse = ApiResponse.loading();

  void setChildListResponse(ApiResponse<List<Child>> response) {
    childListResponse = response;

    notifyListeners();
  }

  ApiResponse<Child> addingChildResponse = ApiResponse.non();
  ApiResponse<AssignRequest> joinKindergartenRequest = ApiResponse.non();

  Future<void> setJoinKindergartenRequest(
      ApiResponse<AssignRequest> response) async {
    joinKindergartenRequest = response;
    notifyListeners();
  }

  void setAddingChildResponse(ApiResponse<Child> apiResponse) {
    addingChildResponse = apiResponse;
    if (apiResponse.data != null) {
     appendNewItems([apiResponse.data!]);
    }

    notifyListeners();
  }

  Future<void> addChild({required ChildForm childForm}) async {
    setAddingChildResponse(ApiResponse.loading());
    _repository.addChild(childForm).then((value) {
      childListResponse.data ??= [];
      setAddingChildResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setAddingChildResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchChildren() async {
    setChildListResponse(ApiResponse.loading());
    _repository
        .getParentChildren(
            page: pageChild, searchKey: searchKey, subUserId: null)
        .then((value) {
      childLastPage = value.item2;
      if(value.item1==null) setChildListResponse(ApiResponse.error("refresh the app"));
        setChildListResponse(ApiResponse.completed(value.item1));
    }).onError((error, stackTrace) {
      setChildListResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextChildren() async {
    if (childLastPage == false) {
      incrementPageChildAction();
      childListResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository
          .getMyChildList(
              page: pageChild, searchKey: searchKey, subUserId: null)
          .then((value) {
        childLastPage = value.item2;
        appendNewItems(value.item1);
      }).onError((error, stackTrace) {
        setChildListResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }

  void incrementPageChildAction() {
    pageChild += 1;
  }

  void appendNewItems(List<Child> value) {
    var data = childListResponse.data;
    data?.addAll(value);
    setChildListResponse(ApiResponse.completed(data));
  }

  void search(String? value) {
    this.searchKey = value;
    fetchChildren();
  }

  Future<void> joinRequest(String childId) async {
    //after request done
    if (requestedKindergartenId != null) {
      await setJoinKindergartenRequest(ApiResponse.loading());
      await _userRepository
          .requestToKindergarten(childId, requestedKindergartenId!)
          .then((value) async {
        await setJoinKindergartenRequest(ApiResponse.completed(value));
        setRequestedKindergartenId(null);
      }).onError((error, stackTrace) async {
        await setJoinKindergartenRequest(ApiResponse.error(error.toString()));
        setRequestedKindergartenId(null);
      });
    }
  }

  void setRequestedKindergartenId(String? id) {
    requestedKindergartenId = id;
  }
}
