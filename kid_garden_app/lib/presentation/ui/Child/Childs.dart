import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildViewModel.dart';
import 'package:kid_garden_app/presentation/ui/genral_components/ChildRow.dart';
import 'package:provider/provider.dart';
import '../../../domain/Child.dart';
import '../../../network/ApiResponse.dart';
import '../genral_components/Error.dart';
import '../genral_components/loading.dart';

class ChildrenExplorer extends StatefulWidget {
  ChildrenExplorer({Key? key}) : super(key: key);

  @override
  _childsExplorerState createState() => _childsExplorerState();
}

class _childsExplorerState extends State<ChildrenExplorer> {
  ChildViewModel viewModel = ChildViewModel();

  @override
  void initState() {
    viewModel.fetchChilds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<ChildViewModel>(
        create: (BuildContext context) => viewModel,
        child: Consumer<ChildViewModel>(builder: (context,viewModel, _){
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
        },),
      ),
    );
  }

  Widget childrenListView(List<Child> children) {
    return ListView.builder(
        itemCount: children.length,
        itemBuilder: (BuildContext context, int index) {
          return ChildRow(
              context: context,
              index: index,
              childImage: children[index].image);
        });
  }
}
