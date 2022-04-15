import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/Modules.dart';
import '../../../them/DentalThem.dart';
import '../../styles/colors_style.dart';
import '../Child/Childs.dart';
import '../Home/HomeUI.dart';
import '../Staff/StaffUI.dart';
import '../general_components/ActionDialog.dart';
import '../parentsScreen/parentsScreen.dart';
import '../profile/ProfileUI.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<NavigationScreen> createState() => _NavigationScreen();
}

class _NavigationScreen extends State<NavigationScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    Home(),
    ChildrenExplorer(
      fromProfile: true,
    ),
    ParentsScreen(),
    StaffUI(),
    ProfileUI(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget get bottomNavigationBar {
    return BottomNavigationBar(
      backgroundColor: ColorStyle.second,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sentiment_satisfied_alt_sharp),
          label: 'Children',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Parents',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle),
          label: 'Staff',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: ColorStyle.main,
      unselectedItemColor: ColorStyle.text3,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: bottomNavigationBar);
  }
}