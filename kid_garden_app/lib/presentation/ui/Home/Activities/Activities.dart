import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/presentation/ui/Home/Activities/ChildInfoRow.dart';

class Activities extends StatelessWidget {
  List<Child> children = [];
  ScrollController scrollController;

  Activities({Key? key, required this.children,   required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
      return ChildInfoRow(child: children[index]);
    });
  }
}
