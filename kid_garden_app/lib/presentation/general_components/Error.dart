import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../them/DentalThem.dart';

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
                // const FaIcon(
                //   FontAwesomeIcons.exclamationCircle,
                //   size: 200,
                //   color: Colors.redAccent,
                // ),
                Image.asset("res/images/error.png",width: 200,height: 200,),

                Text(
                  msg,
                )
              ],
            )));
  }
}
class EmptyWidget extends StatelessWidget {
  final String msg;
  Function? onRefresh;

  EmptyWidget({required this.msg, this.onRefresh});

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
                Image.asset("res/images/no_data.png",width: 200,height: 200,),
                // const FaIcon(
                //   FontAwesomeIcons.exclamationCircle,
                //   size: 200,
                //   color: Colors.amber,
                // ),
                Text(
                  msg,
                )
              ],
            )));
  }
}
