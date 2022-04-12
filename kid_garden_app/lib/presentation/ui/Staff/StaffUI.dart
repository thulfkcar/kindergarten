import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/presentation/ui/Staff/StaffViewModel.dart';

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
import 'addStaff.dart';

class StaffUI extends ConsumerStatefulWidget {
  const StaffUI({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _StaffUIState();
}

class _StaffUIState extends ConsumerState<StaffUI> {
  late ScrollController _scrollController;
  late StaffViewModel _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()..addListener(getNext);
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(staffViewModelProvider);

    return Scaffold(
      body: Column(
        children: [
          InfoCard(
              homeData: Tuple2("Staff Count", "999"),
              startColor: Color(0xFF00962A),
              endColor: Color(0xFFF2A384)),
          Expanded(child: body()),
        ],
      ),
      floatingActionButton: floatingActionButtonAdd22(onClicked: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StaffAdding()));
      }),
    );
  }

  Widget body() {
    var status = _viewModel.childListResponse.status;
    switch (status) {
      case Status.LOADING:
        return LoadingWidget();

      case Status.COMPLETED:
        return CustomListView(
          scrollController: _scrollController,
          items: _viewModel.childListResponse.data!,
          loadNext: false,
          itemBuilder: (BuildContext context, UserModel item) {
            return staffCard(item, (user) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile(
                            userType: item.role,
                            userId: item.id!,
                          )));
            });
          },
          direction: Axis.vertical,
        );
      case Status.ERROR:
        return MyErrorWidget(
            msg: _viewModel.childListResponse.message ?? "Error");

      case Status.LOADING_NEXT_PAGE:
        return CustomListView(
          scrollController: _scrollController,
          items: _viewModel.childListResponse.data!,
          loadNext: true,
          itemBuilder: (BuildContext context, UserModel item) {
            return staffCard(item, (user) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile(
                            userType: item.role,
                            userId: item.id!,
                          )));
            });
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
    var state = _viewModel.childListResponse.status;
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      if (state == Status.COMPLETED && state != Status.LOADING_NEXT_PAGE) {
        await _viewModel.fetchNextStaff();
      }
    }
  }
}
