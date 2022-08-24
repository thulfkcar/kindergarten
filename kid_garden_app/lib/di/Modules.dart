import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/AdminRequestsScreen/AdminRequestsViewModel.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildViewModel.dart';
import 'package:kid_garden_app/presentation/ui/Child/childProfileScreen/ChildProfileViewModel.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/parent/parentChildren/ParentChildrenViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/staff/staffChildren/StaffChildrenViewModel.dart';
import 'package:kid_garden_app/presentation/ui/parentsScreen/parentViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/UserModel.dart';
import '../presentation/ui/Home/HomeViewModel.dart';
import '../presentation/ui/SignUp/SignUpViewModel.dart';
import '../presentation/ui/Staff/StaffViewModel.dart';
import '../presentation/ui/childActions/AssignChildViewModel.dart';
import '../presentation/ui/childActions/ChildActionViewModel.dart';
import '../presentation/ui/kindergartens/kindergartenViewModel.dart';
import '../presentation/ui/navigationX/parent/subscriptionScreen/SubscriptionViewModel.dart';
import '../presentation/ui/userProfile/UserProfileViewModel.dart';

final childViewModelProvider =
    ChangeNotifierProvider.family<ChildViewModel, String?>(
        (ref, subUserId) => ChildViewModel(subUserId: subUserId));

final userProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  var userJson = await prefs.getString("User");
  if (userJson != null && userJson != 'null') {
    Map<String, dynamic> userMap = await jsonDecode(userJson);
    return await UserModel.fromJson(userMap);
  }
});
final parentChildrenViewModelProvider =
    ChangeNotifierProvider.autoDispose<ParentChildrenViewModel>(
        (ref) => ParentChildrenViewModel());
final staffChildrenViewModelProvider =
    ChangeNotifierProvider.autoDispose<StaffChildrenViewModel>(
        (ref) => StaffChildrenViewModel());

final childProfileViewModelProvider =
    ChangeNotifierProvider((ref) => ChildProfileViewModel());

final parentViewModelProvider =
    ChangeNotifierProvider<ParentViewModel>((ref) => ParentViewModel());

final ChildActionViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<ChildActionViewModel, String>(
        (ref, childId) => ChildActionViewModel(childId: childId));

final userProfileViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<UserProfileViewModel, String>(
        (ref, userId) => UserProfileViewModel(userId: userId));

final HomeViewModelProvider =
    ChangeNotifierProvider.family<HomeViewModel, BuildContext>(
        (ref, BuildContext context) => HomeViewModel(context));
final kindergartenViewModelProvider =
    ChangeNotifierProvider.autoDispose<KindergartenViewModel>(
        (ref) => KindergartenViewModel());

final staffViewModelProvider =
    ChangeNotifierProvider<StaffViewModel>((ref) => StaffViewModel());
final adminRequestsViewModelProvider =
    ChangeNotifierProvider.autoDispose<AdminRequestsViewModel>(
        (ref) => AdminRequestsViewModel());

final subscriptionViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<SubscriptionViewModel, bool>(
        (ref, check) => SubscriptionViewModel(check));

final assignChildViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<AssignChildViewModel, String>(
        (ref, childId) => AssignChildViewModel(childId: childId));

final LoginPageViewModelProvider =
    ChangeNotifierProvider.autoDispose<LoginPageViewModel>((ref) {
  var provider = LoginPageViewModel();
  provider.getUserChanges();
  return provider;
});

final signUpViewModelProvider =
    ChangeNotifierProvider.autoDispose<SignUpViewModel>((ref) {
  var provider = SignUpViewModel();
  return provider;
});
