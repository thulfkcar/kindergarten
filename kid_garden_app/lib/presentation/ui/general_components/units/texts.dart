import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';

import '../../../utile/FormValidator.dart';

Widget titleText(String text, Color color, {TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      color: color,
      fontSize: 20,
    ),
  );
}

Widget descriptionText(
  String text,
  Color color,{TextAlign? textAlign}
) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      color: color,
      fontSize: 16,

    ),
  );
}

Widget customTextForm(
    {required Icon icon,
    required String hint,
    required TextInputType textType,
    required Function(String) onChange,
    required String? Function(String?) validator,
    required Function(String?) onSaved}) {
  return TextFormField(
    onChanged: ((text) => onChange(text)),
    keyboardType: textType,
    autofocus: true,
    decoration: InputDecoration(
      prefixIcon: icon,
      hintText: hint,
      contentPadding: const EdgeInsets.fromLTRB(4.0, 15.0, 4.0, 15.0),
      fillColor: ColorStyle.text5,
      filled: true,
      // dont forget this line

      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none),
    ),
    validator: validator,
    onSaved: (String? value) {
      onSaved(value);
    },
  );
}
