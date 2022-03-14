import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';
import '../../../data/network/ApiResponse.dart';

class ChildViewModel extends ChangeNotifier {
  final _repository = ChildRepository();
  var childActionsLastPage = false;
  int pageChildAction = 1;

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
    _repository.getMyChildList(page:pageChildAction).then((value) {
      childActionsLastPage = value.item2;
      setChildListResponse(ApiResponse.completed(value.item1));
    }).onError((error, stackTrace) {
      setChildListResponse(ApiResponse.error(error.toString()));
    });
  }
  

  Future<void> fetchNextChildren() async {
    if (childActionsLastPage == false) {
      incrementPageChildAction();
      childListResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository
          .getMyChildList( page: pageChildAction)
          .then((value) {
        childActionsLastPage = value.item2;
        setChildListResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setChildListResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }
  void incrementPageChildAction() {
    pageChildAction += 1;
  }
  ApiResponse<List<Child>> appendNewItems(List<Child> value) {
    var data = childListResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }
}
