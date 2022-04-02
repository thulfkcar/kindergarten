import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../di/Modules.dart';
import '../../../domain/Child.dart';

import '../general_components/ChildActionRow.dart';
import '../general_components/CustomListView.dart';
import '../general_components/ChildInfoRow.dart';
import '../general_components/Error.dart';
import '../general_components/loading.dart';
import 'HomeViewModel.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeXXState createState() => _HomeXXState();
}

class _HomeXXState extends ConsumerState<Home> {
  late ScrollController _scrollController;
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()..addListener(getNext);
  }

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(HomeViewModelProvider);
    return Scaffold(body:body() );
  }

  Widget body() {
    var status = viewModel.childActionResponse.status;
    switch (status) {
      case Status.LOADING:
        return LoadingWidget();
      case Status.COMPLETED:
        return CustomListView(
          scrollController: _scrollController,
          items: viewModel.childActionResponse.data!,
          loadNext: false,
          itemBuilder: (BuildContext context, ChildAction item) {
            return ChildActionRow(childAction: item);
          },
          direction: Axis.vertical,
        );
      case Status.ERROR:
        return MyErrorWidget(
          msg: viewModel.childActionResponse.message!,
          onRefresh: () {
            viewModel.fetchChildActions();
          },
        );
      case Status.LOADING_NEXT_PAGE:
        return CustomListView(
          scrollController: _scrollController,
          items: viewModel.childActionResponse.data!,
          loadNext: true,
          itemBuilder: (BuildContext context, ChildAction item) {
            return ChildActionRow(childAction: item);
          },
          direction: Axis.vertical,
        );
      case Status.NON:
        break;
      default:
    }
    return Container();
  }


  void getNext() async {
    var state = viewModel.childActivitiesApiResponse.status;
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      if (state == Status.COMPLETED && state != Status.LOADING_NEXT_PAGE) {
        await viewModel.fetchNextChildActions();
      }
    }
  }
}
