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
    ChangeNotifierProvider<LoginPageViewModel>((ref) => LoginPageViewModel());

Future<User?> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  var userJson = prefs.getString("User");
  if (userJson != null) {
    Map<String, dynamic> userMap = jsonDecode(userJson);

    return User.fromJson(userMap);
  }

  // return User("id", DateTime.now(), "name", "email", "admin");

  return null;
}
setUser(User user) async{
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("User", user.toString());

}

final isLoggedInFutureProvider=FutureProvider<User?>((ref) =>  getUser());
