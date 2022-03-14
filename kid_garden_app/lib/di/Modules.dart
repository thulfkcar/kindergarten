import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildViewModel.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/User.dart';
import '../presentation/ui/Home/HomeViewModel.dart';
import '../presentation/ui/childActions/ChildActionViewModel.dart';
import '../presentation/ui/profile/ChildAdding/ChildAddingViewModel.dart';

final childViewModelProvider =
    ChangeNotifierProvider<ChildViewModel>((ref) => ChildViewModel());

final ChildActionViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<ChildActionViewModel,String>(
        (ref,childId) => ChildActionViewModel(childId: childId));

final childPostingViewModelProvider =
    ChangeNotifierProvider.autoDispose<ChildPostingViewModel>(
        (ref) => ChildPostingViewModel());

final HomeViewModelProvider =
    ChangeNotifierProvider<HomeViewModel>((ref) => HomeViewModel());

final LoginPageViewModelProvider =
    ChangeNotifierProvider<LoginPageViewModel>((ref) {
  var provider = LoginPageViewModel();
  provider.getUserChanges();
  return provider;
});

setUser(User? user) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    if (user == null) {
      prefs.setString("User", 'null');
    } else {
      prefs.setString("User", user.toString());
      print(prefs.getString("User"));
    }
  } catch (e) {
    rethrow;
  }
}
