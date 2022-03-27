import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginByPhone.dart';

import '../../main.dart';

class LoginDialog extends StatefulWidget {
  LoginDialog({Key? key, required this.loggedIn}) : super(key: key);
  Function(bool isLoggedIn) loggedIn;

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          content: LoginByPhoneNumber(
            loggedIn: (bool value) {
              widget.loggedIn(value);
              if (value) {

                  Future.delayed(Duration.zero, () async {
                    Navigator.pushReplacementNamed(context, HomeScreenRoute);
                  });
              }
            },
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: const Text("Dismiss"))
          ],
        ));
  }
}

Future<void> showLoginDialog(
    {required BuildContext context, required LoginDialog longinDialog}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return longinDialog;
    },
  );
}
