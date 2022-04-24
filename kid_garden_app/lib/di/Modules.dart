import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildViewModel.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/parentsScreen/parentViewModel.dart';
import '../presentation/ui/Home/HomeViewModel.dart';
import '../presentation/ui/SignUp/SignUpViewModel.dart';
import '../presentation/ui/Staff/StaffViewModel.dart';
import '../presentation/ui/childActions/AssignChildViewModel.dart';
import '../presentation/ui/childActions/ChildActionViewModel.dart';
import '../presentation/ui/kindergartens/kindergartenViewModel.dart';
import '../presentation/ui/navigationScreen/parent/parentChild/ParentChildrenViewModel.dart';
import '../presentation/ui/subscriptionScreen/SubscriptionViewModel.dart';
import '../presentation/ui/userProfile/UserProfileViewModel.dart';

final childViewModelProvider =
    ChangeNotifierProvider.family<ChildViewModel, String?>(
        (ref, subUserId) => ChildViewModel(subUserId: subUserId));

final parentChildrenViewModelProvider =
    ChangeNotifierProvider.autoDispose<ParentChildrenViewModel>((ref) => ParentChildrenViewModel());

final parentViewModelProvider =
    ChangeNotifierProvider<ParentViewModel>((ref) => ParentViewModel());

final ChildActionViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<ChildActionViewModel, String>(
        (ref, childId) => ChildActionViewModel(childId: childId));

final userProfileViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<UserProfileViewModel, String>(
        (ref, userId) => UserProfileViewModel(userId: userId));

final HomeViewModelProvider =
    ChangeNotifierProvider<HomeViewModel>((ref) => HomeViewModel());
final kindergartenViewModelProvider =
    ChangeNotifierProvider<KindergartenViewModel>(
        (ref) => KindergartenViewModel());

final staffViewModelProvider =
    ChangeNotifierProvider<StaffViewModel>((ref) => StaffViewModel());

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
