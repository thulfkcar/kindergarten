import 'package:kid_garden_app/domain/AssignRequest.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/presentation/viewModels/viewModelCollection.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';
import 'package:kid_garden_app/repos/UserRepo.dart';
import '../../../../../data/network/ApiResponse.dart';

class ParentChildrenViewModel extends ViewModelCollection<Child> {
  final _repository = ChildRepository();
  final _userRepository = UserRepository();
  var childLastPage = false;
  int pageChild = 1;

  String? searchKey;


  ParentChildrenViewModel() : super() {
    fetchChildren();
  }


  void setChildListResponse(ApiResponse<List<Child>> response) {
    if(response.data!=null) {
      response.data!.forEach((element) {
        // element.contacts!.removeWhere((element) =>
        // element.userType == "Parent");
      });
    }
    collectionApiResponse = response;

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
    if (collectionApiResponse.data != null && apiResponse.data != null) {
      appendNewItems([apiResponse.data!]);
    } else if (apiResponse.data != null) {
      setChildListResponse(ApiResponse.completed([apiResponse.data!]));
    }

    notifyListeners();
  }

  // Future<void> addChild({required ChildForm childForm}) async {
  //   setAddingChildResponse(ApiResponse.loading());
  //   _repository.addChild(childForm).then((value) {
  //     collectionApiResponse.data ??= [];
  //     setAddingChildResponse(ApiResponse.completed(value));
  //   }).onError((error, stackTrace) {
  //     setAddingChildResponse(ApiResponse.error(error.toString()));
  //   });
  // }

  Future<void> fetchChildren() async {
    setChildListResponse(ApiResponse.loading());
    _repository
        .getParentChildren(
            page: pageChild, searchKey: searchKey, subUserId: null)
        .then((value) {
      childLastPage = value.item2;
      if (value.item1 == null) {
        setChildListResponse(ApiResponse.error("refresh the app"));
      } else if (value.item1.isEmpty) {
        setChildListResponse(ApiResponse.empty());
      } else {
        setChildListResponse(ApiResponse.completed(value.item1));
      }
    }).onError((error, stackTrace) {
      setChildListResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextChildren() async {
    if (childLastPage == false) {

      incrementPageChildAction();
      collectionApiResponse.status = Status.LOADING_NEXT_PAGE;
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




  void search(String? value) {
    this.searchKey = value;
    fetchChildren();
  }




}
