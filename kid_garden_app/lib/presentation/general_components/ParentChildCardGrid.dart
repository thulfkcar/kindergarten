import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/Contact.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';

import '../../data/network/BaseApiService.dart';
import '../../domain/Child.dart';
import '../../them/DentalThem.dart';
import '../styles/colors_style.dart';

class ParentChildCardGrid extends StatelessWidget {
  double height;
  Child child;
  Function() onClicked;

  ParentChildCardGrid(
      {Key? key,
      required this.onClicked,
      required this.child,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        shape: BoxShape.rectangle,
      ),
      child: MaterialButton(
        color: KidThem.text5,
        elevation: 0,
        disabledElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        onPressed: () {
          onClicked();
        },
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                  color: child.gender == Gender.Female
                      ? ColorStyle.female1
                      : ColorStyle.male1,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(height),
                      bottomRight: Radius.circular(height))),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height,
                      width: height,
                      child: ClipOval(
                        child: CachedNetworkImage(fit: BoxFit.cover,
                          imageUrl: '$domain${child.image!}',
                          placeholder: (context, url) => Image.asset("res/images/child.jpg",fit: BoxFit.cover,),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      //   Image.network('$domain${child.image!}',
                      //       fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(right: 13.0),
                                  child: Text(
                                    child.name,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              child.gender == Gender.Female
                                  ? Icon(
                                      Icons.female,
                                      // if child is female gender
                                      // Icons.male,
                                      color: ColorStyle.female1,
                                      // color: ColorStyle.male1,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.male,
                                      // if child is female gender
                                      // Icons.male,
                                      color: ColorStyle.male1,
                                      // color: ColorStyle.male1,
                                      size: 20,
                                    ),
                              Text(
                                child.age.toString(),
                                style: const TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF57636C),
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(right: 13.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.person_pin),
                                      Text(
                                        staffName(context),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF57636C),
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    child.kindergartenName != null
                                        ? Icon(Icons.business_sharp)
                                        : Container(),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        child.kindergartenName != null
                                            ? child.kindergartenName!
                                            : getTranslated(
                                                "not_joined_yet", context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style:  TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: child.kindergartenName != null
                                                ? Colors.blue
                                                : Colors.yellow.shade900,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  staffName(BuildContext context) {
    Iterable<Contact> contacts =
        child.contacts!.where((element) => element.userType == "Staff");
    return contacts.isNotEmpty
        ? contacts.first.name
        : getTranslated("nobody", context);
  }
}
