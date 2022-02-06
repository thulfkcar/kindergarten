import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/Action.dart';

import '../../../domain/ChildAction.dart';
import '../genral_components/ChildActionRow.dart';

class ChildActions extends StatefulWidget {
  String childId;

  ChildActions({Key? key, required this.childId}) : super(key: key);

  @override
  _ChildActionsState createState() => _ChildActionsState();
}

class _ChildActionsState extends State<ChildActions> {
  @override
  Widget build(BuildContext context) {
    var childAction = new ChildAction(
        id: "id",
        action: new ActionGroup(
            id: "id", date: DateTime.now(), name: "actionName"));
    List<ChildAction>? childActions = [
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
        shrinkWrap: true,
        itemCount: childActions.length,
        itemBuilder: (BuildContext context, int index) {
          return ChildActionRow(context: context, index: index);
        });
  }
}
