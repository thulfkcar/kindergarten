import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/presentation/viewModels/viewModelCollection.dart';

import '../../../../../domain/UserModel.dart';
import '../../../../../repos/UserRepo.dart';

class ParentViewModel extends ViewModelCollection<UserModel> {
  final _repository = UserRepository();

  String? searchKey;

  ParentViewModel() : super() {
    fetchParents();
  }

  Future<void> fetchParents() async {
    setCollectionApiResponse(ApiResponse.loading());
    _repository
        .getMyParentsList(page: page, searchKey: searchKey)
        .then((value) {
      lastPage = value.item2;
      if (value.item1.isEmpty) {
        setCollectionApiResponse(ApiResponse.empty());
      } else {
        setCollectionApiResponse(ApiResponse.completed(value.item1));
      }
    }).onError((error, stackTrace) {
      setCollectionApiResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextParents() async {
    if (lastPage == false) {
      incrementPage();
      collectionApiResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository
          .getMyParentsList(page: page, searchKey: searchKey)
          .then((value) {
        lastPage = value.item2;
        setCollectionApiResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setCollectionApiResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }

  void search(String? value) {
    searchKey = value;
    fetchParents();
  }
}
