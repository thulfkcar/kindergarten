import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ChildActions.dart';



class ChildActivity extends StatelessWidget {
  const ChildActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("gosdjfg"),
      ),
      body: ChildActions(childId: '43fdgg4t',),
    );
  }
}
