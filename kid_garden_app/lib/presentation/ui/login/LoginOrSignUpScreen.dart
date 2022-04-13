import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/login/SignUpScreen.dart';
import 'package:kid_garden_app/presentation/ui/subscriptionScreen/SubscriptionScreen.dart';

import '../../main.dart';
import '../general_components/units/texts.dart';
import 'LoginByPhone.dart';

class LoginOrSignUpScreen extends StatelessWidget {
  const LoginOrSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.male1,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: (MediaQuery.of(context).size.height * 0.5),
            decoration: BoxDecoration(
                color: ColorStyle.male1,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
          ),
          Column(
            children: [
              Image.asset(
                "res/images/logo_kindergarten.png",
                height: (MediaQuery.of(context).size.width * 0.4),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: (MediaQuery.of(context).size.height * 0.1),
                    bottom: (MediaQuery.of(context).size.height * 0.3)),
                decoration: BoxDecoration(
                    color: ColorStyle.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      titleText(
                          "Welcome in Phoenix Kindergarten", ColorStyle.text1),
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
                                    builder: (context) => LoginByPhoneNumber(
                                      loggedIn: (isLoggedIn) {
                                        // widget.loggedIn(value);
                                        if (isLoggedIn) {
                                          Future.delayed(Duration.zero,
                                              () async {
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SubscriptionScreen()));

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
                                );
                              },
                              child: titleText("Sign In", ColorStyle.white),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorStyle.male1),
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
                                          Future.delayed(Duration.zero,
                                              () async {
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
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorStyle.white),
                                  side: MaterialStateProperty.all(BorderSide(
                                      width: 1, color: ColorStyle.male1)),
                                  elevation: MaterialStateProperty.all(0)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
