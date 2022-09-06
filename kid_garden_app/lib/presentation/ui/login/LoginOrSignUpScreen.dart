import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/di/Modules.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/general_components/units/texts.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/entrySharedScreen/EntrySharedScreen.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/ActionDialog.dart';
import 'package:kid_garden_app/presentation/ui/SignUp/SignUpScreen.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/admin/AdminScreen.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/parent/ParentScreen.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/parent/subscriptionScreen/SubscriptionScreen.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/parent/subscriptionScreen/SubscriptionViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/staff/StaffScreen.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import '../../../data/network/ApiResponse.dart';
import '../AboutCompany/AboutCompany.dart';
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
    viewModel = ref.watch(subscriptionViewModelProvider(false));
    login_viewModel = ref.read(LoginPageViewModelProvider);
    Future.delayed(Duration.zero, () async {
      checkParentSubscription();
    });

    return EntrySharedScreen(
      body: Column(
        children: [
          titleText(
              AppLocalizations.of(context)?.getText("app_dis") ??
                  "Phoenix Kindergarten Log System.",
              ColorStyle.text1),
          descriptionText(
              AppLocalizations.of(context)?.getText("app_dis_title") ??
                  "Welcome in Phoenix Kindergarten",
              ColorStyle.text1),
          const SizedBox(
            height: 20,
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
                            loggedIn: (user) async {
                              // widget.loggedIn(value);
                              if (user != null) {

                                  Future.delayed(Duration.zero, () async {
                                    navigateToDest();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  child: titleText(
                      AppLocalizations.of(context)?.getText("sign_in") ??
                          "Sign In",
                      ColorStyle.white),
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
                          signedUp: (user) async {
                            Navigator.pop(context);
                            // widget.loggedIn(value);
                            if (user != null) {
                                Future.delayed(Duration.zero, () async {
                                  navigateToDest();
                              });
                            }
                          },
                        ),
                      ),
                    );
                  },
                  child: titleText(
                      AppLocalizations.of(context)?.getText("sign_up") ??
                          "Sign Up",
                      ColorStyle.male1),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorStyle.white),
                      side: MaterialStateProperty.all(
                          BorderSide(width: 1, color: ColorStyle.male1)),
                      elevation: MaterialStateProperty.all(0)),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutCompany(),
                      ),
                    );
                  },
                  child: descriptionText(
                      AppLocalizations.of(context)
                              ?.getText("register_new_kindergarten") ??
                          "register new kindergarten",
                      ColorStyle.female1),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorStyle.white),
                      side: MaterialStateProperty.all(const BorderSide(
                          width: 0, color: Colors.transparent)),
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
                title: getTranslated("Subscription_Check", context),
                message: getTranslated("Subscription_Check_Des", context)));
        // viewModel.setUserSubscriptionStatusResponse(ApiResponse.non());

        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ParentScreen(title: '')),
          (Route<dynamic> route) => false,
        );

        viewModel.setUserSubscriptionStatusResponse(ApiResponse.non());

        break;
      case Status.ERROR:
        Navigator.pop(context);
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => SubscriptionScreen(
                    message:
                        viewModel.userSubscriptionStatusResponse.message != null
                            ? viewModel.userSubscriptionStatusResponse.message!
                            : "corrupted",
                  )),
          (Route<dynamic> route) => false,
        );

        viewModel.setUserSubscriptionStatusResponse(ApiResponse.non());

        break;

      default:
    }
  }
  void navigateToDest() async {

    var user = ref.watch(hiveProvider).value!.getUser();
    user != null
        ? FirebaseMessaging.instance.subscribeToTopic("user_${user.id}")
        : null;
    (user!.role == Role.admin || user.role == Role.superAdmin)
        ? await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => AdminScreen(
                    title: AppLocalizations.of(context)?.getText('app_name') ??
                        "Phoenix kindergarten")),
            (Route<dynamic> route) => false,
          )
        : (user.role == Role.Staff)
            ? await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StaffScreen(title: user.name!)))
            : await viewModel.checkParentSubscription();
  }
}
