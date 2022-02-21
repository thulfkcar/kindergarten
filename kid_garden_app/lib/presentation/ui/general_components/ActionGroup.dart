import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../domain/ActionGroup.dart';

class ActionGroups extends StatefulWidget {
  ActionGroups(
      {Key? key, required this.actionGroups, required this.selectedItem})
      : super(key: key);

  List<ActionGroup> actionGroups;
  Function(ActionGroup) selectedItem;

  @override
  State<ActionGroups> createState() => _ActionGroupsState();
}

class _ActionGroupsState extends State<ActionGroups> {
  int? selectedIndex = null;

  @override
  Widget build(BuildContext context) {
    var backColor = Color(0xA9AAAAAA);

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: widget.actionGroups.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
          width: 55,
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: Color(0xFF898989),
            ),
          ),
          child: InkWell(
            onTap: () {
              setState(
                () {
                  selectedIndex = index;
                  widget.selectedItem(widget.actionGroups[index]);
                },
              );
            },
            child: Container(
              color: index == selectedIndex ? backColor : Colors.transparent,
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.babyCarriage,
                  size: 35,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
