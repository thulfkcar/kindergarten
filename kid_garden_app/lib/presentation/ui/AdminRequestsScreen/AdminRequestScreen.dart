import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/AssignRequest.dart';
import 'package:kid_garden_app/presentation/ui/AdminRequestsScreen/AdminRequestsViewModel.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/dialogs.dart';
import 'package:kid_garden_app/presentation/ui/general_components/ActionDialog.dart';
import 'package:kid_garden_app/presentation/ui/general_components/RequestCard.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../di/Modules.dart';
import '../general_components/CustomListView.dart';
import '../general_components/Error.dart';
import '../general_components/loading.dart';

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
    Future.delayed(Duration.zero, () async {
      await rejectState();
    });
    Future.delayed(Duration.zero, () async {
      await acceptState();
    });


    return Scaffold(body: body());
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
    return RequestCard(
      assignRequest: item,
      onRejectClicked: () {
        showDialogGeneric(
            context: context,
            dialog: InputMessageDialog(
              confirmed: (value) async {
                await showDialogGeneric(
                    context: context,
                    dialog: ConfirmationDialog(
                        title: "Rejection Confirmation",
                        message: "do you want to reject this request?",
                        confirmed: () async {
                          await _viewModel.reject(item.id);
                          // request api
                        }));
              },
              title: 'Reject Reason',
            ));
      },
      onConfirmClicked: () {
        showDialogGeneric(
            context: context,
            dialog: ConfirmationDialog(
                title: 'Confirm Request',
                message: "do you want to Confirm this Request",
                confirmed: () async {
                  await _viewModel.accept(item.id);

                  // request api to confirm this request
                }));
      },
    );
  }

  Future<void> acceptState() async {
    var status = _viewModel.acceptResponse.status;
    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
                type: DialogType.loading,
                title: 'accepting request',
                message: "Request Pending Please waite"));
        _viewModel.setAcceptResponse(ApiResponse.non());
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        await _viewModel.setAcceptResponse(ApiResponse.non()).then((value) =>
            showAlertDialog(
                context: context,
                messageDialog: ActionDialog(
                    type: DialogType.completed,
                    title: 'accepting request',
                    message: "Request Accepted")));

        break;
      case Status.ERROR:
        var message = _viewModel.acceptResponse.message;
        Navigator.pop(context);
        await _viewModel.setAcceptResponse(ApiResponse.non()).then((value) =>
            showAlertDialog(
                context: context,
                messageDialog: ActionDialog(
                    type: DialogType.completed,
                    title: 'Error',
                    message: message!)));
        break;

      default:
    }
  }

  Future<void> rejectState() async {
    var status = _viewModel.rejectResponse.status;
    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
                type: DialogType.loading,
                title: 'rejecting request',
                message: "Request Pending Please waite"));
        _viewModel.setRejectResponse(ApiResponse.non());
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        await _viewModel.setRejectResponse(ApiResponse.non()).then((value) =>
            showAlertDialog(
                context: context,
                messageDialog: ActionDialog(
                    type: DialogType.completed,
                    title: 'rejecting request',
                    message: "Request rejected")));

        break;
      case Status.ERROR:
        var message = _viewModel.rejectResponse.message;
        Navigator.pop(context);
        await _viewModel.setRejectResponse(ApiResponse.non()).then((value) =>
            showAlertDialog(
                context: context,
                messageDialog: ActionDialog(
                    type: DialogType.completed,
                    title: 'Error',
                    message: message!)));
        break;

      default:
    }
  }
}
