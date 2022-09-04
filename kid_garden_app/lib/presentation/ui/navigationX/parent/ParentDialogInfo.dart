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

  const ParentInfoDialog(
      {Key? key, required this.user, required this.subscription})
      : super(key: key);
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

  Widget profile(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                imageRectangleWithoutShadow(domain + user.image!, 90,() {

                }),
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
            SizedBox(height: 16,),

            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    child: Text(
                      getTranslated("scratchDate", context) +
                          " : " +
                          subscription.scratchDate.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF57636C),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(getTranslated("remainingDays", context) +
                    " : " +
                    subscription.remainingDays.toString())
              ],
            ),
          ],
        ));
  }
}
