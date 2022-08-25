import 'package:flutter/material.dart';
import 'package:kid_garden_app/data/network/BaseApiService.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/childActions/ChildActions.dart';
import '../../../domain/Child.dart';
import '../../domain/Contact.dart';
import '../utile/language_constrants.dart';
class ChildRow extends StatelessWidget {
  final Child child;

 final double roundBy;

  final bool boarder;
  const ChildRow({Key? key,
    required this. child,
    this. roundBy = 10,
    this. boarder = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
        decoration: BoxDecoration(
            color: ColorStyle.text4,
            borderRadius: BorderRadius.circular(roundBy)),
        // width: double.infinity,
        // height: 100,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChildActions(
                      childId: child.id,
                    )));
            // Navigator.pushNamed(context, "/ChildActions",arguments: {'id':child.id});
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: SizedBox.fromSize(
                      size: const Size.fromRadius(30),
                      child:  Image.network('$domain${child.image!}', fit: BoxFit.cover)
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          children: [
                            child.gender==Gender.Female?  Icon(
                              Icons.female,
                              // if child is female gender
                              // Icons.male,
                              color: ColorStyle.female1,
                              // color: ColorStyle.male1,
                              size: 20,
                            ): Icon(
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
                        Text(getTranslated("taking_care_by", context)+" "+(child.staffName==null?getTranslated("nobody", context):child.staffName!),
                          style: const TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF57636C),
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF57636C),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  staffName(BuildContext context) {
    Iterable<Contact> contacts =
    child.contacts!.where((element) => element.userType == "Staff");
    return contacts.isNotEmpty
        ? contacts.first.name
        : getTranslated("nobody", context);
  }
}

