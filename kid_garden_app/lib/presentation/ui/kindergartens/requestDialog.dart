import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/presentation/general_components/units/cards.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginByPhone.dart';

import '../../main.dart';

class RequestDialog extends StatefulWidget {
  // RequestDialog({Key? key, required this.loggedIn}) : super(key: key);
  // Function(bool isLoggedIn) loggedIn;

  @override
  State<RequestDialog> createState() => _RequestDialogState();
}

class _RequestDialogState extends State<RequestDialog> {
  late final ScrollController _scrollController = ScrollController();
  int r = 9;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text("Choose Kids",style: TextStyle(fontSize: 24,color: ColorStyle.male1),),
              SizedBox(
                height: 300,
                width: 300,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, r) {
                    return radioChildCard();
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    /// send the request to admin
                  });
                },
                child:  Text("Send",style: TextStyle(color: ColorStyle.main),)),
            TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child:  Text("Dismiss",style: TextStyle(color: ColorStyle.error),)),
          ],
        ));
  }
}

Future<void> showRequestDialog(
    {required BuildContext context,
    required RequestDialog requestDialog}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return requestDialog;
    },
  );
}
