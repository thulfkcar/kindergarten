
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/domain/AssignRequest.dart';
import 'package:kid_garden_app/presentation/ui/AdminRequestsScreen/AdminRequestsViewModel.dart';
import 'package:kid_garden_app/presentation/ui/Staff/StaffViewModel.dart';
import 'package:kid_garden_app/presentation/ui/general_components/RequestCard.dart';

import 'package:kid_garden_app/presentation/ui/general_components/StaffCard.dart';
import 'package:kid_garden_app/presentation/ui/userProfile/UserProfile.dart';
import 'package:tuple/tuple.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../di/Modules.dart';
import '../../../domain/UserModel.dart';
import '../general_components/CustomListView.dart';
import '../general_components/Error.dart';
import '../general_components/InfoCard.dart';
import '../general_components/loading.dart';
import '../general_components/units/cards.dart';
import '../general_components/units/floating_action_button.dart';

class AdminRequestsScreen extends ConsumerStatefulWidget {
  const AdminRequestsScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends ConsumerState<AdminRequestsScreen> {
  late ScrollController _scrollController;
  late AdminRequestsViewModel _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()..addListener(getNext);
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(adminRequestsViewModelProvider);

    return Scaffold(
      body:
       body());




  }

  Widget body() {
    var status = _viewModel.adminRequestsResponse.status;
    switch (status) {
      case Status.LOADING:
        return LoadingWidget();

      case Status.COMPLETED:
        return CustomListView(
          scrollController: _scrollController,
          items: _viewModel.adminRequestsResponse.data!,
          loadNext: false,
          itemBuilder: (BuildContext context, AssignRequest item) {
            return adminRequestCard(item);
          },
          direction: Axis.vertical,
        );
      case Status.ERROR:
        return MyErrorWidget(
            msg: _viewModel.adminRequestsResponse.message ?? "Error");

      case Status.LOADING_NEXT_PAGE:
        return CustomListView(
          scrollController: _scrollController,
          items: _viewModel.adminRequestsResponse.data!,
          loadNext: true,
          itemBuilder: (BuildContext context, AssignRequest item) {
            return adminRequestCard(item);
          },
          direction: Axis.vertical,
        );

      case Status.NON:
        return Container();
      default:
    }
    return Container();
  }

  void getNext() async {
    var state = _viewModel.adminRequestsResponse.status;
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      if (state == Status.COMPLETED && state != Status.LOADING_NEXT_PAGE) {
        await _viewModel.fetchNextRequests();
      }
    }
  }

  Widget adminRequestCard(AssignRequest item) {

    return RequestCard(assignRequest: item);

  }
}
