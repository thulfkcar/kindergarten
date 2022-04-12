import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/domain/Contact.dart';
import 'package:kid_garden_app/presentation/ui/general_components/units/cards.dart';
import 'package:kid_garden_app/presentation/ui/general_components/units/texts.dart';

import '../../styles/colors_style.dart';

class ContactList extends StatelessWidget {
  Contact contact;

  ContactList({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            descriptionText("Name :", ColorStyle.text1),
            descriptionText(contact.name+" :: ", ColorStyle.text2),
            descriptionText(contact.role.name, ColorStyle.text2),
            Expanded(child: Container())
          ],
        ),
        Row(
          children: [
            descriptionText("Phone :", ColorStyle.text1),
            descriptionText(contact.phone, ColorStyle.text2),
            Expanded(child: Container())
          ],
        ),
      contact.email!=null?  Row(
          children: [
            descriptionText("Email :", ColorStyle.text1),
            descriptionText(contact.email!, ColorStyle.text2),
            Expanded(child: Container())
          ],
        ):Container(),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            roundedClickableWithIcon(
                size: 30, icon: const Icon(FontAwesomeIcons.sms), onClicked: () {}),
            roundedClickableWithIcon(
                size: 30, icon: const Icon(FontAwesomeIcons.phone), onClicked: () {}),
         contact.email!=null?   roundedClickableWithIcon(
                size: 30,
                icon: const Icon(FontAwesomeIcons.solidEnvelope),
                onClicked: () {}):Container(),
            roundedClickableWithIcon(
                size: 30,
                icon: Icon(FontAwesomeIcons.telegram,
                    color: Colors.blue.shade800),
                onClicked: () {}),
            roundedClickableWithIcon(
                size: 30,
                icon: const Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                ),
                onClicked: () {}),
          ],
        )
      ],
    );
  }
}
