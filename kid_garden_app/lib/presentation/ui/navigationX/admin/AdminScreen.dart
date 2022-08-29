import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/userProfile/UserProfile.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';

import '../../../../di/Modules.dart';
import '../../../../domain/UserModel.dart';
import '../../../../them/DentalThem.dart';
import '../../../styles/colors_style.dart';
import '../../../utile/language_constrants.dart';
import '../../Child/Childs.dart';
import '../../Home/HomeUI.dart';
import '../../Staff/StaffUI.dart';
import '../../dialogs/ActionDialog.dart';
import '../../parentsScreen/parentsScreen.dart';
import 'adminProfile/AdminProfileScreen.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<AdminScreen> createState() => _NavigationScreen();
}

class _NavigationScreen extends ConsumerState<AdminScreen> {
  // int _selectedIndex = 0;
  // static final List<Widget> _widgetOptions = <Widget>[
  //   Home(),
  //   ChildrenExplorer(
  //     fromProfile: true,
  //   ),
  //   ParentsScreen(),
  //   StaffUI(),
  //   UserProfile(self: true, userType: Role.admin, userId: null),
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
  //     items: <BottomNavigationBarItem>[
  //       BottomNavigationBarItem(
  //         icon: const Icon(Icons.home_filled),
  //         label: getTranslated("home", context),
  //       ),
  //       BottomNavigationBarItem(
  //         icon: const Icon(Icons.sentiment_satisfied_alt_sharp),
  //         label: getTranslated("children", context),
  //       ),
  //       BottomNavigationBarItem(
  //         icon: const Icon(Icons.person),
  //         label: getTranslated("parents", context),
  //       ),
  //       BottomNavigationBarItem(
  //         icon: const Icon(Icons.supervised_user_circle),
  //         label: getTranslated("staff", context),
  //       ),
  //       BottomNavigationBarItem(
  //         icon: const Icon(Icons.account_circle),
  //         label: getTranslated("profile", context),
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
    return Scaffold(
        appBar: AppBar(
          leading: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0)),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>const AdminProfileScreen()));

              },
              child: const Icon(Icons.person_outline_outlined,size: 25,)),

          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0)),
                onPressed: () async {
                 var user=ref.watch(hiveProvider).value!.getUser();
                    showAlertDialog(
                        context: context,
                        messageDialog: ActionDialog(
                            type: DialogType.qr,
                            qr: user!.id,
                            title: getTranslated("self_identity", context),
                            message:
                                getTranslated("scan_for_Operation", context)));

                },
                child: const Icon(Icons.qr_code))
          ],
          automaticallyImplyLeading: true,

          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          // Here we take the value from the MyHomePage object that was created by
          // the app.build method, and use it to set our appbar title.
          title: Text(
            widget.title,
            style: TextStyle(color: KidThem.textTitleColor),
          ),
        ),
        body: Home(),
        // body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        // bottomNavigationBar: bottomNavigationBar
    );
  }
}
