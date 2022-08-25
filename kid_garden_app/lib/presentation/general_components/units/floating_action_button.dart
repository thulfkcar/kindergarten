import 'package:flutter/material.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';

Widget floatingActionButtonAdd22({required Function() onClicked}) {
  return FloatingActionButton(
    onPressed: () {
      onClicked();
    },
    backgroundColor: ColorStyle.main,
    child: Icon(
      Icons.add,
      color: ColorStyle.white,
    ),
  );
}
