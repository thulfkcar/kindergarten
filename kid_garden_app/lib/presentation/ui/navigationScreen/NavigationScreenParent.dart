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

class NavigationScreenParent extends ConsumerStatefulWidget {
  NavigationScreenParent({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<NavigationScreenParent> createState() =>
      _NavigationScreenParentState();
}

class _NavigationScreenParentState
    extends ConsumerState<NavigationScreenParent> {
  late SubscriptionViewModel viewModel;
  late LoginPageViewModel viewModelLogin;

  // int _selectedIndex = 0;
  // static final List<Widget> _widgetOptions = <Widget>[
  //   ChildrenExplorer(
  //     fromProfile: true,
  //   ),
  //   UserProfile(
  //     userType: Role.Parents,
  //     userId: null,
  //   ),
  // ];
  //
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  // Widget get bottomNavigationBar {
  //   return BottomNavigationBar(
  //     backgroundColor: ColorStyle.second,
  //     items: const <BottomNavigationBarItem>[
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.sentiment_satisfied_alt_sharp),
  //         label: 'Children',
  //       ),
  //       /**/
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.account_circle),
  //         label: 'Profile',
  //       ),
  //     ],
  //     currentIndex: _selectedIndex,
  //     selectedItemColor: ColorStyle.main,
  //     unselectedItemColor: ColorStyle.text3,
  //     onTap: _onItemTapped,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(subscriptionViewModelProvider(true));
    viewModelLogin = ref.watch(LoginPageViewModelProvider);
    Future.delayed(Duration.zero, () async {
      checkParentSubscription();
    });
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

  checkParentSubscription() async {
    var status = viewModel.userSubscriptionStatusResponse.status;

    switch (status) {
      case Status.LOADING:
        // showAlertDialog(
        //     context: context,
        //     messageDialog: ActionDialog(
        //         type: DialogType.loading,
        //         title: "Subscription Check",
        //         message: "please wait until your Subscription Checked"));

        break;
      case Status.COMPLETED:
        await viewModel
            .setUserSubscriptionStatusResponse(ApiResponse.non())
            .then((value) async {
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NavigationScreenParent(title: 'Parent App')),
            (Route<dynamic> route) => false,
          );
        });

        break;
      case Status.ERROR:
        var errorMessage=viewModel
            .userSubscriptionStatusResponse.message !=
            null
            ? viewModel.userSubscriptionStatusResponse.message!
            : "corrupted";
        await viewModel
            .setUserSubscriptionStatusResponse(ApiResponse.non())
            .then((value) async {
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => SubscriptionScreen(
                      message:errorMessage
                    )),
            (Route<dynamic> route) => true,
          );
        });

        break;

      default:
    }
  }
}
