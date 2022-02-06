import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import 'package:kid_garden_app/domain/Media.dart';
import 'package:kid_garden_app/presentation/ui/genral_components/ChildRow.dart';

import '../../../domain/Child.dart';
import '../../../them/DentalThem.dart';

class ChildrenExplorer extends StatefulWidget {
  ChildrenExplorer({Key? key}) : super(key: key);

  @override
  _childsExplorerState createState() => _childsExplorerState();
}

class _childsExplorerState extends State<ChildrenExplorer> {
  @override
  Widget build(BuildContext context) {
    final List<Child> children = [
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
    ];

    return Scaffold(
      body: ListView.builder(
          itemCount: children.length,
          itemBuilder: (BuildContext context, int index) {
            return ChildRow(context: context, index: index, childImage: children[index].image);


          }),
    );
  }
}
