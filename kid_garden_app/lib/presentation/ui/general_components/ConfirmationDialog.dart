import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  String message;
  String title;
  Function() confirmed;

  ConfirmationDialog(
      {required this.title,
      required this.message,
      required this.confirmed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Text(
                    message,
                  )),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  await confirmed();
                  Navigator.pop(context);
                },
                child: const Text("Confirm")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"))
          ],
        ));
  }
}
Future<void> showDialogGeneric(
    {required BuildContext context,
      required Widget dialog}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return dialog;
    },
  );
}
