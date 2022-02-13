import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/presentation/ui/Home/Activities/ChildInfoRow.dart';

class Activities extends StatelessWidget {
  List<Child> children = [];

  Activities({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
      return ChildInfoRow(child: children[index]);
    });
  }
}
