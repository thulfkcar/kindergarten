import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';



Widget imageCircleWithoutShadow( String url, double size) {
  return Container(
    padding: EdgeInsets.all(4),
    margin: EdgeInsets.all(4),
    width: size,
    height: size,
    // clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      // borderRadius: const BorderRadius.all(
      //   Radius.circular(50),
      // ),
      // border: Border.all(width: 3, color: ColorStyle.main),
      image: DecorationImage(
        alignment: Alignment.center,
        fit: BoxFit.fill,
        image: NetworkImage(
          url,
        ),
      ),
      shape: BoxShape.circle,
    ),
  );
}

Widget imageRectangleWithoutShadow(
     String url, double size) {
  return Container(
    padding: EdgeInsets.zero,
    margin: const EdgeInsets.all(2),
    width: size,
    height: size,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      border: Border.all(width: 1, color: ColorStyle.male1),
      image: DecorationImage(
        image: NetworkImage(
           url,
        ),
      ),
      shape: BoxShape.rectangle,
    ),
    child: MaterialButton(
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      onPressed: () {},
      padding: EdgeInsets.zero,
    ),
  );
}



