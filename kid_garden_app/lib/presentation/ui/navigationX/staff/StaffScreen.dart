import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/staff/staffChildren/StaffChildrenScreen.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';

import '../../../../di/Modules.dart';
import '../../../../domain/UserModel.dart';
import '../../../../them/DentalThem.dart';
import '../../Child/Childs.dart';
import '../../dialogs/ActionDialog.dart';
import '../../kindergartens/kindergartenScreen.dart';
import '../../userProfile/UserProfile.dart';

class StaffScreen extends ConsumerStatefulWidget {
  StaffScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<StaffScreen> createState() => _NavigationScreenParentState();
}

class _NavigationScreenParentState extends ConsumerState<StaffScreen> {
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
                var user = ref.watch(hiveProvider).value!.getUser();

                showAlertDialog(
                    context: context,
                    messageDialog: ActionDialog(
                        type: DialogType.qr,
                        qr: user!.id,
                        title: getTranslated("self_identity", context),
                        message: getTranslated("scan_for_Operation", context)));
              },
              child: const Icon(Icons.qr_code)),
        ],
        leading: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0)),
            onPressed: () async {
              Future.delayed(Duration.zero, () async {
                await ref.watch(hiveProvider).value!.storeUser(null);

                // RestartWidget.restartApp(context);

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const KindergartenScreen()),
                    (route) => false);
              });
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => UserProfile(self: true,
              //           userType: Role.Parents,
              //           userId: null,
              //         )));
            },
            child: const Icon(Icons.logout)),
        automaticallyImplyLeading: true,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: TextStyle(color: KidThem.textTitleColor),
        ),
      ),
      body: Center(child: StaffChildrenScreen()),
      // body: Center(child: _widgetOptions.elementAt(_selectedIndex))
      // bottomNavigationBar: bottomNavigationBar
    );
  }
}
