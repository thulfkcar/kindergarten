import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import 'package:kid_garden_app/presentation/ui/genral_components/ChildRow.dart';

import '../../../../domain/Child.dart';

class ChildInfoRow extends StatelessWidget {
  final Child child;

  ChildInfoRow({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),


        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 0.5),
            color: Colors.white70,
            borderRadius: BorderRadius.circular(30)),
        child: Column(
      children: [
        ChildRow(context: context, child: child, roundBy: 0,boarder :false),
        ListView.builder(
            // scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: child.childActions!.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return ChildPrefActivity(childAction: child.childActions![index]);
            })
      ],
    ));
  }

  Widget ChildPrefActivity({required ChildAction childAction}) {
    return Container(
      decoration: BoxDecoration(
          // border: Border.all(color: Colors.black12, width: 0.5),
          color: Colors.white70,
          borderRadius: BorderRadius.circular(30)),
      margin: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Color(0xFFDBE2E7),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
              child: Icon(
                Icons.share_rounded,
                color: Color(0xFF57636C),
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    childAction.actionGroup!.name,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}