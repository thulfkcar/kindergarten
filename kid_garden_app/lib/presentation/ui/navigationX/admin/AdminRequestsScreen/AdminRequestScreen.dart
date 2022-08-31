import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/AssignRequest.dart';
import 'package:kid_garden_app/presentation/general_components/CustomListView.dart';
import 'package:kid_garden_app/presentation/general_components/Error.dart';
import 'package:kid_garden_app/presentation/general_components/RequestCard.dart';
import 'package:kid_garden_app/presentation/general_components/loading.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/dialogs.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/ActionDialog.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/admin/AdminRequestsScreen/AdminRequestsViewModel.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';

import '../../../../../data/network/ApiResponse.dart';
import '../../../../../di/Modules.dart';
import '../../../../utile/language_constrants.dart';

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

    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated("join_requests", context)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: body());
  }

  Widget body() {
    var status = _viewModel.collectionApiResponse.status;
    switch (status) {
      case Status.LOADING:
        return LoadingWidget();

      case Status.COMPLETED:
        return assignRequestsList(loadingNext: false);
      case Status.ERROR:
        return MyErrorWidget(
          msg: _viewModel.collectionApiResponse.message ?? "Error",
          onRefresh: () async {
            await _viewModel.fetchRequests();
          },
        );

      case Status.LOADING_NEXT_PAGE:
        return assignRequestsList(loadingNext: true);
      case Status.Empty:
        return EmptyWidget(
          msg:getTranslated("no_assign_requests", context),
          onRefresh: () async {
            await _viewModel.fetchRequests();
          },
        );

      case Status.NON:
        return Container();
      default:
    }
    return Container();
  }

  void getNext() async {
    var state = _viewModel.collectionApiResponse.status;
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
                        title: AppLocalizations.of(context)
                                ?.getText("reject_title") ??
                            "Rejection Confirmation",
                        message: AppLocalizations.of(context)
                                ?.getText("reject_des") ??
                            "do you want to reject this request?",
                        confirmed: () async {
                          await _viewModel.reject(item.id, value);
                          // request api
                        }));
              },
              title: AppLocalizations.of(context)?.getText("reject_reason") ??
                  'Reject Reason',
            ));
      },
      onConfirmClicked: () {
        showDialogGeneric(
            context: context,
            dialog: ConfirmationDialog(
                title:
                    AppLocalizations.of(context)?.getText("confirm_request") ??
                        'Confirm Request',
                message: AppLocalizations.of(context)
                        ?.getText("confirm_request_des") ??
                    "do you want to Confirm this Request",
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
                title: AppLocalizations.of(context)
                        ?.getText("accepting_request") ??
                    'accepting request',
                message: AppLocalizations.of(context)
                        ?.getText("accepting_request_des") ??
                    "Request Pending Please waite"));
        _viewModel.setAcceptResponse(ApiResponse.non());
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        await _viewModel.setAcceptResponse(ApiResponse.non()).then((value) =>
            showAlertDialog(
                context: context,
                messageDialog: ActionDialog(
                    type: DialogType.completed,
                    title: AppLocalizations.of(context)
                            ?.getText("accepting_request") ??
                        'accepting request',
                    message: AppLocalizations.of(context)
                            ?.getText("request_accepted") ??
                        "Request Accepted")));

        break;
      case Status.ERROR:
        var message = _viewModel.acceptResponse.message;
        Navigator.pop(context);
        await _viewModel.setAcceptResponse(ApiResponse.non()).then((value) =>
            showAlertDialog(
                context: context,
                messageDialog: ActionDialog(
                    type: DialogType.error,
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
                title: AppLocalizations.of(context)
                        ?.getText("rejecting_request") ??
                    'rejecting request',
                message: AppLocalizations.of(context)
                        ?.getText("rejecting_request_des") ??
                    "Request Pending Please waite"));
        _viewModel.setRejectResponse(ApiResponse.non());
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        await _viewModel.setRejectResponse(ApiResponse.non()).then((value) =>
            showAlertDialog(
                context: context,
                messageDialog: ActionDialog(
                    type: DialogType.completed,
                    title: AppLocalizations.of(context)
                            ?.getText("rejecting_request") ??
                        'rejecting request',
                    message: AppLocalizations.of(context)
                            ?.getText("request_rejected") ??
                        "Request rejected")));

        break;
      case Status.ERROR:
        var message = _viewModel.rejectResponse.message;
        Navigator.pop(context);
        await _viewModel.setRejectResponse(ApiResponse.non()).then((value) =>
            showAlertDialog(
                context: context,
                messageDialog: ActionDialog(
                    type: DialogType.error,
                    title: 'Error',
                    message: message!)));
        break;

      default:
    }
  }

  Widget assignRequestsList({required bool loadingNext}) {
    return CustomListView(
      scrollController: _scrollController,
      items: _viewModel.collectionApiResponse.data!,
      loadNext: loadingNext,
      itemBuilder: (BuildContext context, AssignRequest item) {
        return adminRequestCard(item);
      },
      direction: Axis.vertical,
    );
  }
}
