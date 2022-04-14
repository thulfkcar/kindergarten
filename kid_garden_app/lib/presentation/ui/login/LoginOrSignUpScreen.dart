import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/entrySharedScreen/EntrySharedScreen.dart';
import 'package:kid_garden_app/presentation/ui/login/SignUpScreen.dart';
import 'package:kid_garden_app/presentation/ui/subscriptionScreen/SubscriptionScreen.dart';

import '../../main.dart';
import '../general_components/units/texts.dart';
import '../navigationScreen/NavigationScreenParent.dart';
import '../navigationScreen/NavigationsScreen.dart';
import 'LoginByPhone.dart';

class LoginOrSignUpScreen extends StatelessWidget {
  const LoginOrSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      EntrySharedScreen(
        body: Column(
          children: [
            titleText("Welcome in Phoenix Kindergarten", ColorStyle.text1),
            descriptionText(
                "Phoenix Kindergarten Log System.", ColorStyle.text1),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntrySharedScreen(
                            body: LoginByPhoneNumber(
                              loggedIn: (isLoggedIn) {
                                // widget.loggedIn(value);
                                if (isLoggedIn) {
                                  Future.delayed(Duration.zero, () async {
                                    var user = await viewModel.getUserChanges();
                                    Widget screen;
                                    (user!.role == Role.admin ||
                                            user.role == Role.superAdmin)
                                        ? screen = const NavigationScreen(
                                            title: "kinderGarten")
                                        : (user.role == Role.Staff)
                                            ? screen = Container()
                                            : screen =
                                                const SubscriptionScreen();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => screen));

                                    // if (user?.role == Role.Parents) {
                                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>SubscriptionScreen()));
                                    // } else {
                                    //   Navigator.pushReplacementNamed(
                                    //       context, HomeScreenRoute);
                                    // }
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: titleText("Sign In", ColorStyle.white),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorStyle.male1),
                        elevation: MaterialStateProperty.all(0)),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(
                            signedUp: (isLoggedIn) {
                              // widget.loggedIn(value);
                              if (isLoggedIn) {
                                Future.delayed(Duration.zero, () async {
                                  Navigator.pushReplacementNamed(
                                      context, HomeScreenRoute);
                                });
                              }
                            },
                          ),
                        ),
                      );
                    },
                    child: titleText("Sign Up", ColorStyle.male1),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ColorStyle.white),
                        side: MaterialStateProperty.all(
                            BorderSide(width: 1, color: ColorStyle.male1)),
                        elevation: MaterialStateProperty.all(0)),
                  ),
                )
              ],
            )
          ],
        ),

    );
  }
}
