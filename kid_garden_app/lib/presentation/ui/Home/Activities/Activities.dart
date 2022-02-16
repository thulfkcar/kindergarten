import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/presentation/ui/Home/Activities/ChildInfoRow.dart';
import 'package:kid_garden_app/presentation/ui/genral_components/loading.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext contet, T item);

class CustomListView<T> extends StatelessWidget {
  List<T> items = [];
  ScrollController scrollController;
  bool loadNext = false;
  final ItemWidgetBuilder<T> itemBuilder;

  CustomListView({
    Key? key,
    required this.scrollController,
    required this.items,
    required this.loadNext,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
          controller: scrollController,
           itemCount: items.length,

          itemBuilder: (BuildContext context, int index) {
            return itemBuilder(context, items[index]);

            // return InkWell(child: ChildInfoRow(child: items[index] as dynamic));
          },
        ),
      ),
      if (loadNext)
        loading(() {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        })
    ]);
  }

  Widget loading(Function scroll) {
    scroll;
    return const Padding(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
