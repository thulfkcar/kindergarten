import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildViewModel.dart';
import 'package:kid_garden_app/presentation/ui/Home/Activities/Activities.dart';
import 'package:kid_garden_app/providers/Providers.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../domain/Child.dart';
import '../general_components/ChildRow.dart';
import '../general_components/Error.dart';
import '../general_components/loading.dart';


// class ChildrenExplorer extends StatefulWidget {
//   ChildrenExplorer({Key? key}) : super(key: key);
//
//   @override
//   _childsExplorerState createState() => _childsExplorerState();
// }

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
          return childRow(context: context, child: children[index]);
        });
  }
}

class ChildrenExplorer extends ConsumerStatefulWidget {
  const ChildrenExplorer({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ChildrenExplorerState();
}

class _ChildrenExplorerState extends ConsumerState<ChildrenExplorer> {
  late ScrollController _scrollController;
  late ChildViewModel _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController=ScrollController()..addListener(getNext);
  }
  @override
  Widget build(BuildContext context) {
    _viewModel=ref.watch(childViewModelProvider);
    var status=_viewModel.childListResponse.status;
    switch (status){
      case Status.LOADING:
        LoadingWidget();
        break;
      case Status.COMPLETED:
        return CustomListView(scrollController: _scrollController,
            items: _viewModel.childListResponse.data!,
            loadNext: false, itemBuilder: (BuildContext context,Child item){
          return childRow(context: context, child: item);
        });
      case Status.ERROR:
        ErrorWidget(_viewModel.childListResponse.message ?? "Error");
        break;
      case Status.LOADING_NEXT_PAGE:
        return CustomListView(scrollController: _scrollController,
            items: _viewModel.childListResponse.data!,
            loadNext: true,
            itemBuilder: (BuildContext context,Child item){
          return childRow(context: context, child: item);
        });

      case Status.NON:
        return Container();
      default:
    }
    return Container();
  }

  void getNext() async {
    var state = _viewModel.childListResponse.status;
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      if (state == Status.COMPLETED && state != Status.LOADING_NEXT_PAGE) {
        await _viewModel.fetchNextChildren();
      }
    }
  }
}
