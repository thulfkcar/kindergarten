import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/domain/Contact.dart';
import 'package:kid_garden_app/presentation/ui/general_components/units/cards.dart';
import 'package:kid_garden_app/presentation/ui/general_components/units/texts.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../styles/colors_style.dart';

class ContactList extends StatelessWidget {
  Contact contact;
   bool controls=false;
  ContactList(this.controls, {Key? key, required this.contact}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            descriptionText("${AppLocalizations.of(context)?.getText("name")??"Name" } :" , ColorStyle.text1),
            descriptionText(contact.name + " :: ", ColorStyle.text2),
            descriptionText(contact.userType, ColorStyle.text2),
            Expanded(child: Container())
          ],
        ),
        Row(
          children: [
            descriptionText("${AppLocalizations.of(context)?.getText("phone")??"Phone" } :", ColorStyle.text1),
            descriptionText(contact.phone, ColorStyle.text2),
            Expanded(child: Container())
          ],
        ),
        contact.email != null
            ? Row(
                children: [
                  descriptionText("${AppLocalizations.of(context)?.getText("email")??"Email" } :", ColorStyle.text1),
                  descriptionText(contact.email!, ColorStyle.text2),
                  Expanded(child: Container())
                ],
              )
            : Container(),
        const SizedBox(
          height: 4,
        ),
        controls==true?  Row(
          children: [
            roundedClickableWithIcon(
                size: 30,
                icon: const Icon(FontAwesomeIcons.sms),
                onClicked: () async {


                  var whatsappUrl ='sms:${contact.phone}';
                  await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");

                }),
            roundedClickableWithIcon(
                size: 30,
                icon: const Icon(FontAwesomeIcons.phone),
                onClicked: () async {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: contact.phone,
                  );
                  await launchUrl(launchUri);
                }),
            contact.email != null
                ? roundedClickableWithIcon(
                    size: 30,
                    icon: const Icon(FontAwesomeIcons.solidEnvelope),
                    onClicked: () async {
                      final mailtoUri = Uri(
                          scheme: 'mailto',
                          path: contact.email,
                            queryParameters: {'subject': 'Example'});
                      await launchUrl(mailtoUri);
                    })
                : Container(),
            // roundedClickableWithIcon(
            //     size: 30,
            //     icon: Icon(FontAwesomeIcons.telegram,
            //         color: Colors.blue.shade800),
            //     onClicked: () async {
            //       var telegram ="https://telegram.me/${contact.phone}";
            //       await canLaunch(telegram)? launch(telegram):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
            //     }),
            roundedClickableWithIcon(
                size: 30,
                icon: const Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                ),
                onClicked: () async {

                  var whatsappUrl ="https://wa.me/${contact.phone}?text=hello";
                  await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                }),
          ],
        ):Container()
      ],
    );
  }
}
