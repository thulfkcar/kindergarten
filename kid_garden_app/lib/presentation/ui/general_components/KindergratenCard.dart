import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/domain/Kindergraten.dart';

class KindergartenCard extends StatelessWidget {
  Kindergraten kindergraten;

  KindergartenCard({Key? key, required this.kindergraten}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child:kindergraten.media !=null ? Image.network(
                kindergraten.media!.url,
                width: 10,
                height: 10,
              ):Image.asset("res/images/default_action_group.png",width: 70,
                height: 70,),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kindergraten.name),
                Text("about ${kindergraten.ditance} meter"),
                Text(kindergraten.location),
                Text(kindergraten.phone)
              ],
            )
          ],
        ),
      ),
    );
  }
}
