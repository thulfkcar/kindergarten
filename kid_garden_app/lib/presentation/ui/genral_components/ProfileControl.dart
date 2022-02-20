import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileControl extends StatelessWidget {
  IconData? icon;
  String title;
  Function() onPressed;

  ProfileControl(
      {Key? key,
      required this.icon,
      required this.title,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
          onTap: () => onPressed(),
          leading: ClipOval(
            child: Icon(icon),
          ),
          title: Text(title),
          trailing: Icon(Icons.chevron_right)),
      Divider(
        color: Colors.grey,
        thickness: 0.5,
      )
    ]);
  }
}
