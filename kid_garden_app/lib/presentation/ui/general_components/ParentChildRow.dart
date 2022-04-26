import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/AssignRequest.dart';
import 'package:kid_garden_app/domain/Contact.dart';
import 'package:kid_garden_app/domain/Kindergraten.dart';
import 'package:kid_garden_app/domain/Media.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/ui/general_components/ContactList.dart';
import 'package:kid_garden_app/presentation/ui/general_components/KindergratenCard.dart';
import 'package:kid_garden_app/presentation/ui/general_components/units/texts.dart';

import '../../../data/network/BaseApiService.dart';
import '../../../domain/Child.dart';
import '../../styles/colors_style.dart';

class ParentChildCard extends ConsumerStatefulWidget {
  Child child;
  Function(Child) onClicked;
  Function(String) onChildActionsClicked;
  Function(String) onKindergartenClicked;
  Function(String) onJoinKindergartenClicked;

  ParentChildCard({
    required this.onChildActionsClicked,
    required this.onJoinKindergartenClicked,
    required this.onKindergartenClicked,
    required this.onClicked,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ParentChildCardState();
}

class _ParentChildCardState extends ConsumerState<ParentChildCard> {
  @override
  Widget build(BuildContext context) {
    return ParentchildRow(
        child: widget.child,
        onClicked: widget.onClicked,
        onChildActionsClicked: widget.onChildActionsClicked,
        onJoinKindergartenClicked: widget.onJoinKindergartenClicked,
        onKindergartenClicked: widget.onKindergartenClicked);
  }
}

ParentchildRow(
    {required Child child,
    required Function(Child) onClicked,
    required Function(String) onChildActionsClicked,
    required Function(String) onJoinKindergartenClicked,
    required Function(String) onKindergartenClicked}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: childCard(onClicked, child),
                ),
                Container(
                  color: ColorStyle.text1,
                  width: 1,
                ),
                actionButton(child, onChildActionsClicked)
              ],
            ),
          ),
          Container(
            color: ColorStyle.text1,
            height: 1,
          ),
          ContactCard(child.contacts),
          Container(
            color: ColorStyle.text1,
            height: 1,
          ),
          child.assignRequest != null
              ? child.assignRequest!.requestStatus == RequestStatus.Pending
                  ? requestedToKindergartenCard(
                      child.assignRequest!, onKindergartenClicked)
                  : (KindergartenButton(
                      child.kindergartenId, onKindergartenClicked))
              : joinKindergartenCard(child.id, onJoinKindergartenClicked),
        ],
      ),
    ),
  );
}

Widget requestedToKindergartenCard(
    AssignRequest assignRequest, Function(String) onKindergartenClicked) {
  var status = assignRequest.requestStatus;
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: status == RequestStatus.Pending
                ? Container(
                    color: ColorStyle.main,
                    child: Center(
                      child: titleText("Request Pending", ColorStyle.text1),
                    ))
                : status == RequestStatus.Rejected
                    ? Container(
                        color: ColorStyle.female1,
                        child: Center(
                            child: titleText(
                                "Request Rejected due :${assignRequest.message}",
                                ColorStyle.text1)),
                      )
                    : Container(),
          )
        ],
      ),
      assignRequest.kindergartenId != null
          ? KindergartenButton(
              assignRequest.kindergartenId, onKindergartenClicked)
          : Container()
    ],
  );
}

Widget ContactCard(List<Contact>? contacts) {
  return contacts != null
      ? Container(
          color: ColorStyle.text5,
          padding: EdgeInsets.all(10),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // Let the ListView know how many items it needs to build.
            itemCount: contacts.length,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              final item = contacts[index];

              return ContactList(
                contact: item,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Container(height: 1, color: Colors.black);
            },
          ),
        )
      : Container();
}

Widget joinKindergartenCard(String childId, Function(String) onJoinClicked) {
  return ElevatedButton(
    onPressed: () {
      onJoinClicked(childId);
    },
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: titleText("Click to Join", ColorStyle.text1),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: descriptionText(
                  "your Child is not implemented in a kindergarten",
                  ColorStyle.text1,
                  textAlign: TextAlign.center)),
        )
      ],
    ),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorStyle.text4),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
        ))),
  );
}

Widget childCard(Function(Child p1) onClicked, Child child) {
  return ElevatedButton(
    onPressed: () {
      onClicked(child);
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
                child:
                    Image.network('$domain${child.image!}', fit: BoxFit.cover)),
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
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(ColorStyle.text4),
      elevation: MaterialStateProperty.all(0),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
        ),
      ),
    ),
  );
}

Widget KindergartenButton(String? id, Function(String) onKindergartenClicked) {
  var kinder = Kindergraten(
      id: '',
      longitudes: 34545,
      ditance: '50 meter',
      latitudes: 3455,
      location: 'najaf kufa',
      phone: '4565656',
      media: Media("sfdf", "Resources/kinder.jpg", MediaType.image),
      name: '');
  return ElevatedButton(
    onPressed: () {
      onKindergartenClicked(kinder.id);
    },
    child: KindergartenCard(
      kindergraten: kinder,
      addRequestEnable: false,
      onAddRequestClicked: (String) {},
    ),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorStyle.text4),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
        ))),
  );
}

Widget actionButton(Child child, Function(String) onChildActionsClicked) {
  return ElevatedButton(
    onPressed: () {
      onChildActionsClicked(child.id);
    },
    child: titleText("Actions", ColorStyle.white),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorStyle.text3),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
        ))),
  );
}
