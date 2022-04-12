import 'package:flutter/material.dart';

import '../../../styles/colors_style.dart';

// FloatingActionButton floatingActionButtonAdd(void Function()? f) {
//   return FloatingActionButton(
//     onPressed: (){},
//     backgroundColor: ColorStyle.main,
//     child: const Icon(Icons.add),
//   );
// }

Widget customButton  ({required String text, required IconData icon,
    required Color mainColor, required Color backgroundColor, void Function()? onPressed}) {
  return Padding(
    padding: const EdgeInsets.all(0),
    child: MaterialButton(
      height: 40,
      padding: const EdgeInsets.only(left: 20, right: 20),
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
            size: 20,
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
