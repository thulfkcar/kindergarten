import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/network/BaseApiService.dart';
import '../../domain/Child.dart';
import '../../them/DentalThem.dart';
import '../styles/colors_style.dart';

class ParentChildCardGrid extends StatelessWidget {

   Child child;
   double size;
   Function() onClicked;
   ParentChildCardGrid({Key? key,required this.onClicked,required this.size,required this.child}) : super(key: key);

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
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox.fromSize(
                          size:  const Size.fromRadius(60),
                          child:
                          Image.network('$domain${child.image!}', fit: BoxFit.cover)),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              child.name,
                              style: const TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF090F13),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
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
                            child.staffName != null
                                ? Text(
                              "Taking care by: " + child.staffName.toString(),
                              style: const TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF57636C),
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

