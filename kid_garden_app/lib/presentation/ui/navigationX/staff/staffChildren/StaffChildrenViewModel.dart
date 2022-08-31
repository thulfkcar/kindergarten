import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/presentation/viewModels/viewModelCollection.dart';
import '../../../../../data/network/ApiResponse.dart';
import '../../../../../repos/ChildRepository.dart';

class StaffChildrenViewModel extends ViewModelCollection<Child>{
  final _repository = ChildRepository();

  String? searchKey;

  StaffChildrenViewModel() : super() {
    fetchChildren();
  }





  Future<void> fetchChildren() async {
    setCollectionApiResponse(ApiResponse.loading());
    _repository.getStaffChildren(page: page,searchKey:searchKey).then((value) {
      lastPage = value.item2;
      setCollectionApiResponse(ApiResponse.completed(value.item1));
      if(value.item1.isEmpty){
        setCollectionApiResponse(ApiResponse.empty());
      }
    }).onError((error, stackTrace) {
      setCollectionApiResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextChildren() async {
    if (lastPage == false) {
      incrementPage();
      collectionApiResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository.getStaffChildren(page: page,searchKey: searchKey).then((value) {
        lastPage = value.item2;
        setCollectionApiResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setCollectionApiResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }



  void search(String? value) {
    searchKey=value;
    fetchChildren();
  }
}