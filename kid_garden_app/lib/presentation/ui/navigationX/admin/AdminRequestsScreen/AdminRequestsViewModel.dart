import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/AssignRequest.dart';
import 'package:kid_garden_app/presentation/viewModels/viewModelCollection.dart';

import '../../../../../data/network/ApiResponse.dart';
import '../../../../../repos/UserRepo.dart';

class AdminRequestsViewModel extends ViewModelCollection<AssignRequest> {


  final UserRepository _repository = UserRepository();

  ApiResponse<AssignRequest> acceptResponse = ApiResponse.non();
  ApiResponse<AssignRequest> rejectResponse = ApiResponse.non();


  Future<void> setAcceptResponse(ApiResponse<AssignRequest> response) async {
    acceptResponse = response;
    if (response.data != null) await updateList(response.data!);
    notifyListeners();
  }

  Future<void> setRejectResponse(ApiResponse<AssignRequest> response) async {
    rejectResponse = response;
    if (response.data != null)  await updateList(response.data!);

    notifyListeners();
  }

  AdminRequestsViewModel() : super() {
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    setCollectionApiResponse(ApiResponse.loading());
    _repository.getAdminRequests(page: page).then((value) {
      lastPage = value.item2;
      if(value.item1.isEmpty){
        setCollectionApiResponse(ApiResponse.empty());
      }
      else {
        setCollectionApiResponse(ApiResponse.completed(value.item1));
      }
    }).onError((error, stackTrace) {
      setCollectionApiResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextRequests() async {
    if (lastPage == false) {
      incrementPage();
      collectionApiResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository.getAdminRequests(page: page).then((value) {
        lastPage = value.item2;
        setCollectionApiResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setCollectionApiResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }





  Future<void> reject(String id, String message) async {
    await setRejectResponse(ApiResponse.loading());
    await _repository.rejectRequest(id, message).then((value) async {
      await setRejectResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) async {
      setRejectResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> accept(String id) async {
    await setAcceptResponse(ApiResponse.loading());
    await _repository.acceptRequest(id).then((value) async {
      await setAcceptResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) async {
      await setAcceptResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> updateList(AssignRequest request) async {
    if (collectionApiResponse.data != null) {
      int index = collectionApiResponse.data!
          .indexWhere((element) => element.id == request.id);
      if (index >= 0) {
        collectionApiResponse.data!.removeAt(index);
        collectionApiResponse.data!.insert(index, request);
      }
    }
    notifyListeners();
  }
}
