import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../di/Modules.dart';
import '../../../domain/UserModel.dart';
import '../../../them/DentalThem.dart';
import '../Child/Childs.dart';
import '../general_components/ActionDialog.dart';
import '../subscriptionScreen/SubscriptionScreen.dart';
import '../subscriptionScreen/SubscriptionViewModel.dart';
import '../userProfile/UserProfile.dart';

class NavigationScreenStaff extends ConsumerStatefulWidget {
  NavigationScreenStaff({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<NavigationScreenStaff> createState() =>
      _NavigationScreenParentState();
}

class _NavigationScreenParentState
    extends ConsumerState<NavigationScreenStaff> {
  late LoginPageViewModel viewModelLogin;



  @override
  Widget build(BuildContext context) {
    viewModelLogin = ref.watch(LoginPageViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0)),
              onPressed: () async {
                var provide =
                ProviderContainer().read(LoginPageViewModelProvider);
                await provide.getUserChanges();
                var user = provide.currentUser;
                showAlertDialog(
                    context: context,
                    messageDialog: ActionDialog(
                        type: DialogType.qr,
                        qr: user!.id,
                        title: "your QR Identity",
                        message: "Scan To Make Opration"));
              },
              child: const Icon(Icons.qr_code)),
        ],
        leading: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0)),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile(
                        userType: Role.Parents,
                        userId: null,
                      )));
            },
            child: const Icon(Icons.person)),
        automaticallyImplyLeading: true,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: TextStyle(color: KidThem.textTitleColor),
        ),
      ),
      body: Center(
        child: ChildrenExplorer(
          fromProfile: true,
        ),
      ),
      // body: Center(child: _widgetOptions.elementAt(_selectedIndex))
      // bottomNavigationBar: bottomNavigationBar
    );
  }

}
