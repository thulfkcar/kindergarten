import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/providers/Providers.dart';

import '../../../network/ApiResponse.dart';
import '../genral_components/Error.dart';
import '../genral_components/loading.dart';
import 'Activities/Activities.dart';
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

    return Scaffold(body: body());
  }

  Widget body() {
    Activities? activities;
    switch (viewModel.childActivitiesApiResponse.status) {
      case Status.LOADING_NEXT_PAGE:
        print("thug :: Loading next page");
        break;
      case Status.LOADING:
        print("thug :: LOADING");
        return LoadingWidget();
      case Status.ERROR:
        print("thug :: ERROR");
        return MyErrorWidget(
            viewModel.childActivitiesApiResponse.message ?? "NA");
      case Status.COMPLETED:
        print("thug :: COMPLETED");
        activities ??= Activities(
          scrollController: _scrollController,
          children: viewModel.childActivitiesApiResponse.data!,
        );
        return activities;
      default:
    }

    return Container();
  }

  void getNext() async{
    var state = viewModel.childActivitiesApiResponse.status;

      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (state == Status.COMPLETED && state != Status.LOADING_NEXT_PAGE) {
          print("bottom end");
          await viewModel.fetchNextChildrenWithInfo();
        }
      }
    }
  }

