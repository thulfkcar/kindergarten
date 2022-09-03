import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildViewModel.dart';
import 'package:kid_garden_app/presentation/ui/Child/childProfileScreen/ChildProfileViewModel.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/admin/AdminRequestsScreen/AdminRequestsViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/parent/parentChildren/ParentChildrenViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/staff/staffChildren/StaffChildrenViewModel.dart';
import '../data/Local/HiveDB.dart';
import '../presentation/ui/navigationX/admin/Dashboard/HomeViewModel.dart';
import '../presentation/ui/SignUp/SignUpViewModel.dart';
import '../presentation/ui/navigationX/admin/Staff/StaffViewModel.dart';
import '../presentation/ui/childActions/AssignChildViewModel.dart';
import '../presentation/ui/childActions/ChildActionViewModel.dart';
import '../presentation/ui/kindergartens/kindergartenViewModel.dart';
import '../presentation/ui/navigationX/admin/parentsScreen/parentViewModel.dart';
import '../presentation/ui/navigationX/parent/subscriptionScreen/SubscriptionViewModel.dart';
import '../presentation/ui/userProfile/UserProfileViewModel.dart';

final LoginPageViewModelProvider =
    ChangeNotifierProvider.autoDispose<LoginPageViewModel>((ref) {
  var provider = LoginPageViewModel();
  return provider;
});

final hiveProvider = FutureProvider<HiveDB>((_) => HiveDB.create());
final childViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<ChildViewModel, String?>(
        (ref, subUserId) => ChildViewModel(subUserId: subUserId));

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
    ChangeNotifierProvider.autoDispose<StaffViewModel>((ref) => StaffViewModel());
final adminRequestsViewModelProvider =
    ChangeNotifierProvider.autoDispose<AdminRequestsViewModel>(
        (ref) => AdminRequestsViewModel());

final subscriptionViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<SubscriptionViewModel, bool>(
        (ref, check) => SubscriptionViewModel(check));

final assignChildViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<AssignChildViewModel, String>(
        (ref, childId) => AssignChildViewModel(childId: childId));

final signUpViewModelProvider =
    ChangeNotifierProvider.autoDispose<SignUpViewModel>((ref) {
  var provider = SignUpViewModel();
  return provider;
});
