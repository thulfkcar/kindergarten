import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/Action.dart';
import 'package:kid_garden_app/domain/Action.dart';

import '../../../domain/ChildAction.dart';
import '../../../them/DentalThem.dart';

class ChildActions extends StatefulWidget {

  String childId;
   ChildActions({Key? key,required this.childId}) : super(key: key);


  @override
  _ChildActionsState createState() => _ChildActionsState();
}

class _ChildActionsState extends State<ChildActions> {
  @override
  Widget build(BuildContext context) {
   var childAction = new  ChildAction(id: "id", action: new ActionGroup(id: "id", date: DateTime.now(), name: "actionName"));
    List<ChildAction>?childActions=[
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
      childAction,
    ];

    return ListView.builder(
        itemCount: childActions.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 0.5),
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(30)),
              child: TextButton(
                  onPressed: () {},
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: const EdgeInsets.all(12), // Border width
                          decoration: const BoxDecoration(
                              color: KidThem.imageBakGround,
                              shape: BoxShape.circle),
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(16),
                              // Image radius
                              // child: Image.network('https://192.168.1.108:5126/StaticFiles/images/img.png',
                              child: Image.network(
                                  'https://picsum.photos/250?image=9',
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Expanded(child: Text(childActions[index].action.name)),
                        Icon(Icons.arrow_right_alt)
                      ],
                    ),
                  )));
        });
  }
}
