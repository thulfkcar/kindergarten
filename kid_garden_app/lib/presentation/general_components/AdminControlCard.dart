import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import '../styles/colors_style.dart';

class AdminControlCard extends StatelessWidget {
 final Tuple2<String,String> listControl;
 final Function() onClicked;
 const  AdminControlCard( {Key? key,required this.listControl,required this.onClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        elevation: 0,
        disabledElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        padding: EdgeInsets.zero,
        color: ColorStyle.text4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          onClicked();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(listControl.item2,style: TextStyle(fontSize: 18),),
                ],
              ),
              Row(
                children: [
                  Text(listControl.item1,style: TextStyle(color: Colors.grey),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
