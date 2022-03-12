import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/User.dart';
import 'package:kid_garden_app/presentation/main.dart';
import 'package:kid_garden_app/presentation/ui/profile/ChildAdding/ChildAddingScreen.dart';
import 'package:kid_garden_app/them/DentalThem.dart';
import '../../../domain/Child.dart';
import '../../../providers/Providers.dart';
import '../general_components/ProfileControl.dart';
import 'EditProfiileDialog.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({Key? key}) : super(key: key);

  @override
  _ProfileUIState createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  var isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        var viewModel = ref.watch(LoginPageViewModelProvider);
        viewModel.getUserChanges();
        var user = viewModel.currentUser;
        if (user != null) {
          return Scaffold(
            body: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: KidThem.lightTheme.primaryColor,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            2, 2, 2, 2),
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        'assets/images/UI_avatar_2@3x.png',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 16, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              width: 2,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                              size: 24,
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                isEditing = true;
                                              });
                                            },
                                          )),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12, 0, 0, 0),
                                        child: Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              width: 2,
                                            ),
                                          ),
                                          child: Consumer(
                                            builder: (context, ref, child) {
                                              return IconButton(
                                                icon: const Icon(
                                                  Icons.login_rounded,
                                                  size: 24,
                                                ),
                                                onPressed: () async {
                                                  ref
                                                      .read(
                                                          LoginPageViewModelProvider)
                                                      .logOut();
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, Login_Page);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 12, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(user.name!),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        children: [
                          (user.role == Role.admin)
                              ? ProfileControl(
                                  icon: Icons.account_tree_rounded,
                                  title: "My Staff",
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pushNamed(
                                          context, StaffUI_Route);
                                    });
                                  })
                              : Container(),
                          (user.role == Role.admin || user.role == Role.Staff)
                              ? ProfileControl(
                                  icon: Icons.baby_changing_station,
                                  title: "Add Child",
                                  onPressed: () async {
                                    var result = Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChildAddingScreen()));
                                    if (await result is Child) {
//add child
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(SnackBar(
                                            content: Text(
                                                (await result as Child).name)));
                                    }
                                  })
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isEditing)
                  EditProfile(
                    proceedEditing: (userForm) =>
                        setState(() => isEditing = false),
                    canceled: () => setState(() => isEditing = false),
                  ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
