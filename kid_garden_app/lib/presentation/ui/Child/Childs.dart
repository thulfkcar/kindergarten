import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildViewModel.dart';
import 'package:kid_garden_app/providers/Providers.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../domain/Child.dart';
import '../general_components/ChildRow.dart';
import '../general_components/Error.dart';
import '../general_components/loading.dart';


class ChildrenExplorer extends StatefulWidget {
  ChildrenExplorer({Key? key}) : super(key: key);

  @override
  _childsExplorerState createState() => _childsExplorerState();
}

class _childsExplorerState extends State<ChildrenExplorer> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer(
      builder: (context, ref, child) {
        final viewModel = ref.watch(childViewModelProvider);
        switch (viewModel.childListResponse.status) {
          case Status.LOADING:
            print("thug :: LOADING");
            return LoadingWidget();
          case Status.ERROR:
            print("thug :: ERROR");
            return MyErrorWidget(viewModel.childListResponse.message ?? "NA");
          case Status.COMPLETED:
            print("thug :: COMPLETED");
            return childrenListView(viewModel.childListResponse.data!);
          default:
        }
        return Container();
      },
    ));
  }

  Widget childrenListView(List<Child> children) {
    return ListView.builder(
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
          return ChildRow(context: context, child: children[index]);
        });
  }
}
