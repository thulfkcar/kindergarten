import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/Redeem.dart';
import 'package:tuple/tuple.dart';

import '../../../../data/network/BaseApiService.dart';
import '../../../../domain/Contact.dart';
import '../../../../domain/UserModel.dart';
import '../../../general_components/ContactList.dart';
import '../../../general_components/InfoCard.dart';
import '../../../general_components/units/images.dart';
import '../../../utile/language_constrants.dart';

class ParentInfoDialog extends StatelessWidget {
  final Redeem subscription;

  const ParentInfoDialog({Key? key, required this.user, required  this.subscription}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [profile(context)],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text(getTranslated("done", context)),
            )
          ],
        ));
  }

  Widget profile( BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                imageRectangleWithoutShadow(domain + user.image!, 90),

                Column(
                  children: [
                ContactListCard(false,
                    contact: Contact(
                        name: user.name!,
                        email: user.email,
                        phone: user.phone!,
                        userType: user.role.name.toString()))
                  ],
                ),
              ],
            ),
            Row(children: [Text("remainingDays" + " : "+ subscription.remainingDays.toString())],),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InfoCard(
                  homeData: Tuple2(getTranslated("total_actions", context),
                      user.actionsCount != null
                          ? (user.actionsCount.toString())
                          : "0"),
                  startColor: Color(0xFFA1B327),
                  endColor: Color(0xFFF2A384),
                  width: 100,
                ),
                MaterialButton(
                  padding: EdgeInsets.all(0),
                  minWidth: 0,
                  onPressed: () {},
                  child: InfoCard(
                    homeData: Tuple2(
                        getTranslated("children", context) ,
                        user.childrenCount != null
                            ? user.childrenCount.toString()
                            : "0"),
                    startColor: Color(0xff89C7E7),
                    endColor: Color(0xFFF2A384),
                    width: 100,
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
