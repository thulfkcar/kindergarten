import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/Child.dart';
import 'package:kid_garden_app/providers/Providers.dart';

import '../../../network/ApiResponse.dart';
import '../genral_components/Error.dart';
import '../genral_components/loading.dart';
import 'Activities/Activities.dart';
import 'HomeViewModel.dart';
import 'HomeViewModel.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final viewModel = ref.watch(HomeViewModelProvider);
          switch (viewModel.childActivitiesApiResponse.status) {
            case Status.LOADING:
              print("thug :: LOADING");
              return LoadingWidget();
            case Status.ERROR:
              print("thug :: ERROR");
              return MyErrorWidget(
                  viewModel.childActivitiesApiResponse.message ?? "NA");
            case Status.COMPLETED:
              print("thug :: COMPLETED");
              return ActivitiesListView(
                  viewModel.childActivitiesApiResponse.data!);
            default:
          }

          return Container();
        },
      ),
    );
  }

  Widget ActivitiesListView(List<Child> data) {
    return Activities(
      children: data,
    );
  }
}
