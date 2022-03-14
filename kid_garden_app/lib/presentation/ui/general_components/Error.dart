import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyErrorWidget extends StatelessWidget {
  final String msg;
  Function? onRefresh;

  MyErrorWidget({required this.msg, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (onRefresh != null) {
            onRefresh!();
          }
        },
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.exclamationCircle,
              size: 200,
              color: Colors.redAccent,
            ),
            Text(
              msg,
            )
          ],
        )));
  }
}
