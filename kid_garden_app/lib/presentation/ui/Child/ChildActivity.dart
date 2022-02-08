import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ChildActions.dart';

class ChildActivity extends StatelessWidget {
  const ChildActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Child Activity"),
      ),
      body: ChildActions(
        childId: '43fdgg4t',
      ),
    ));
  }
}
