import 'package:flutter/material.dart';

import '../../../styles/colors_style.dart';

// FloatingActionButton floatingActionButtonAdd(void Function()? f) {
//   return FloatingActionButton(
//     onPressed: (){},
//     backgroundColor: ColorStyle.main,
//     child: const Icon(Icons.add),
//   );
// }

Widget customButton  ({ double size=20,double paddingEdges=20,required String text, required IconData icon,
    required Color mainColor, required Color backgroundColor, void Function()? onPressed}) {
  return Padding(
    padding: const EdgeInsets.all(0),
    child: MaterialButton(
      height: size*2,
      padding:  EdgeInsets.only(left: paddingEdges, right: paddingEdges),
      color: backgroundColor,
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      splashColor: const Color(0x7fffffff),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: mainColor,
            size: size,
          ),
          const SizedBox(width: 6, height: 1),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: mainColor,
            ),
          ),
        ],
      ),
    ),
  );
}
