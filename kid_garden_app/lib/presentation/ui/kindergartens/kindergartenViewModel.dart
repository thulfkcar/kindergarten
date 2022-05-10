import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/domain/Kindergraten.dart';

import '../../../repos/KindergartenRepository.dart';
import '../general_components/KindergratenCard.dart';

class KindergartenViewModel extends ChangeNotifier {
  Position? position;

  KindergartenViewModel() : super() {
    fetchKindergarten();
  }

  var KindergartenLastPage = false;
  int pageKindergarten = 1;

  String? searchKey;
  final _repository = KindergartenRepository();

  var kindergartenApiResponse = ApiResponse.non();

  void setKindergartenApiResponse(ApiResponse response) {
    kindergartenApiResponse = response;
    notifyListeners();
  }

  Future<void> fetchKindergarten() async {
    setKindergartenApiResponse(ApiResponse.loading());

    await _determinePosition()
        .then((value) => setPosition(value))
        .onError((error, stackTrace) => {});

    _repository
        .getMyKindergartenList(
            page: pageKindergarten, searchKey: searchKey, position: position)
        .then((value) {
      KindergartenLastPage = value.item2;
      setKindergartenApiResponse(ApiResponse.completed(value.item1));
    }).onError((error, stackTrace) {
      setKindergartenApiResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<void> fetchNextKindergarten() async {
    if (KindergartenLastPage == false) {
      incrementPageKindergartenAction();
      kindergartenApiResponse.status = Status.LOADING_NEXT_PAGE;
      notifyListeners();

      _repository
          .getMyKindergartenList(
              page: pageKindergarten, searchKey: searchKey, position: position)
          .then((value) {
        KindergartenLastPage = value.item2;
        setKindergartenApiResponse(appendNewItems(value.item1));
      }).onError((error, stackTrace) {
        setKindergartenApiResponse(ApiResponse.error(error.toString()));
      });
      notifyListeners();
    }
  }

  void incrementPageKindergartenAction() {
    pageKindergarten += 1;
  }

  ApiResponse<List<Kindergraten>> appendNewItems(List<Kindergraten> value) {
    var data = kindergartenApiResponse.data;
    data?.addAll(value);
    return ApiResponse.completed(data);
  }

  void search(String? value) {
    this.searchKey = value;
    fetchKindergarten();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  setPosition(Position value) {
    position = value;
  }
}
