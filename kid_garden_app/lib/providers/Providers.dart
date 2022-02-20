import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildViewModel.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/User.dart';
import '../presentation/ui/Home/HomeViewModel.dart';
import '../presentation/ui/childActions/ChildActionViewModel.dart';

final childViewModelProvider =
    ChangeNotifierProvider<ChildViewModel>((ref) => ChildViewModel());
final ChildActionViewModelProvider =
    ChangeNotifierProvider.autoDispose<ChildActionViewModel>(
        (ref) => ChildActionViewModel());
final HomeViewModelProvider =
    ChangeNotifierProvider<HomeViewModel>((ref) => HomeViewModel());
final LoginPageViewModelProvider =
    ChangeNotifierProvider<LoginPageViewModel>((ref) {
  return LoginPageViewModel();
});



setUser(User? user) async {
  final prefs = await SharedPreferences.getInstance();
  if (user == null) prefs.setString("User", 'null');
  prefs.setString("User", user.toString());
}

