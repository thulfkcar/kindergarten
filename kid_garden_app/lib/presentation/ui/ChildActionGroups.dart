import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/ActionGroup.dart';
class ChildActionsGroups extends StatefulWidget {
  const ChildActionsGroups({Key? key}) : super(key: key);

  @override
  _ChildActionsGroupsState createState() => _ChildActionsGroupsState();
}

class _ChildActionsGroupsState extends State<ChildActionsGroups> {
  @override
  Widget build(BuildContext context) {

    var actionGroup=ActionGroup(id: "id", date: DateTime.now(), name: "ActionGroupNmae",image: "");
    List<ActionGroup> actionsGroups=[
      actionGroup,
      actionGroup,actionGroup,actionGroup,actionGroup,actionGroup,actionGroup,actionGroup
    ];
    return ListView.builder(

      shrinkWrap: true,

        itemCount: actionsGroups.length,
        itemBuilder: (BuildContext context, int index) {

        return  Container(
            margin: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
          decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 0.5),
          color: Colors.white70,
          borderRadius: BorderRadius.circular(30)),
          child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEEEEEE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF4B39EF),
                              size: 24,
                            ),
                          ),
                        ),
                        const Text(
                          'UserName',
                          style:  TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF090F13),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Overall',
                          style: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF090F13),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: const [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                              child: Text(
                                '5',
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF57636C),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.star_rounded,
                              color: Color(0xFF4B39EF),
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Expanded(
                      child: Text(
                        'Nice outdoor courts, solid concrete and good hoops for the neighborhood.',
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF57636C),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));

        });
  }
}
