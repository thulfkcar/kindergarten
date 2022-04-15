import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/di/Modules.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/entrySharedScreen/EntrySharedScreen.dart';
import 'package:kid_garden_app/presentation/ui/general_components/ActionDialog.dart';
import 'package:kid_garden_app/presentation/ui/SignUp/SignUpScreen.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/subscriptionScreen/SubscriptionScreen.dart';
import 'package:kid_garden_app/presentation/ui/subscriptionScreen/SubscriptionViewModel.dart';

import '../../../data/network/ApiResponse.dart';
import '../../main.dart';
import '../general_components/units/texts.dart';
import '../navigationScreen/NavigationScreenParent.dart';
import '../navigationScreen/NavigationsScreen.dart';
import 'LoginByPhone.dart';

class LoginOrSignUpScreen extends ConsumerStatefulWidget {
  const LoginOrSignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoginOrSignUpScreenState();
}

class _LoginOrSignUpScreenState extends ConsumerState<LoginOrSignUpScreen> {
  late SubscriptionViewModel viewModel;
  late LoginPageViewModel login_viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(subscriptionViewModelProvider);
    login_viewModel = ref.read(LoginPageViewModelProvider);
    Future.delayed(Duration.zero, () async {
      checkParentSubscription();
    });

    return EntrySharedScreen(
      body: Column(
        children: [
          titleText("Welcome in Phoenix Kindergarten", ColorStyle.text1),
          descriptionText("Phoenix Kindergarten Log System.", ColorStyle.text1),
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
                                  var user =
                                      await login_viewModel.getUserChanges();
                                  (user!.role == Role.admin ||
                                          user.role == Role.superAdmin)
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NavigationScreen(
                                                      title: "kindergarten")))
                                      : (user.role == Role.Staff)
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Container()))
                                          : await viewModel
                                              .checkParentSubscription();
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

  checkParentSubscription() async {
    var status = viewModel.userSubscriptionStatusResponse.status;

    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
                type: DialogType.loading,
                title: "Subscription Check",
                message: "please wait until your Subscription Checked"));
        break;
      case Status.COMPLETED:
        viewModel.setUserSubscriptionStatusResponse(ApiResponse.non());
        //    Navigator.pop(context);
        //   showAlertDialog(
        //       context: context,
        //       messageDialog: ActionDialog(
        //         type: DialogType.completed,
        //         title: "Subscription Check",
        //         message: viewModel.userSubscriptionStatusResponse.data!,
        //         onCompleted: (s) {
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) =>
        //                       NavigationScreenParent(title: user.name!)));
        //          viewModel.setUserSubscriptionStatusResponse(ApiResponse.non());
        //
        //         },
        //       ));

        Navigator.pop(context);
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.completed,
              title: "Subscription Check",
              message: "please wait until your Subscription Checked",
              onCompleted: (s) {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationScreenParent(title: "Parent App",)));

              },
            ));
        break;
      case Status.ERROR:
        Navigator.pop(context);
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.error,
              title: "Subscription Check",
              message: "please wait until your Subscription Checked",
              onCompleted: (s) {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubscriptionScreen(
                              message: viewModel.userSubscriptionStatusResponse
                                          .message !=
                                      null
                                  ? viewModel
                                      .userSubscriptionStatusResponse.message!
                                  : "corrupted",
                            )));
                // viewModel.setUserSubscriptionStatusResponse(ApiResponse.non());

              },
            ));

        break;

      default:
    }
  }
}