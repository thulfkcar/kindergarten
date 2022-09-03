import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/AssignRequest.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/dialogs.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import '../../../../../data/network/ApiResponse.dart';
import '../../../../../di/Modules.dart';
import '../../../../../domain/UserModel.dart';
import '../../../../../them/DentalThem.dart';
import '../../../../general_components/CustomListView.dart';
import '../../../../general_components/Error.dart';
import '../../../../general_components/loading.dart';
import '../../../../general_components/units/cards.dart';
import '../../../../general_components/units/texts.dart';
import '../../../childActions/AssignChildViewModel.dart';
import '../../../dialogs/ActionDialog.dart';
import '../Staff/StaffViewModel.dart';
import 'AssignRequestByQR.dart';

class AssignScreen extends ConsumerStatefulWidget {
  final String? childId;
final Function(UserModel) onAssignCompleted;

  const AssignScreen({
    required this.onAssignCompleted,
    required this.childId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AssingScreenState();
}

class _AssingScreenState extends ConsumerState<AssignScreen> {
  late ScrollController _scrollController;
  late StaffViewModel _viewModel;
  late AssignChildViewModel _viewModelAssignChild;

  UserModel? selectedStaff;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()..addListener(getNext);
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(staffViewModelProvider);
    _viewModelAssignChild =
        ref.watch(assignChildViewModelProvider(widget.childId!));
    Future.delayed(Duration.zero, () async {
      assignChildResponse();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated("staff", context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: body()),
        ],
      ),
    );
  }

  Widget body() {
    var status = _viewModel.collectionApiResponse.status;
    switch (status) {
      case Status.LOADING:
        return LoadingWidget();

      case Status.COMPLETED:
        return staffList(loadNext: false);
      case Status.ERROR:
        return MyErrorWidget(
          msg: _viewModel.collectionApiResponse.message ?? "Error",
          onRefresh: () async {
            await _viewModel.fetchStaff();
          },
        );
      case Status.Empty:
        return EmptyWidget(
          msg: getTranslated("no_staff", context),
          onRefresh: () async {
            await _viewModel.fetchStaff();
          },
        );

      case Status.LOADING_NEXT_PAGE:
        return staffList(loadNext: true);

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
        await _viewModel.fetchNextStaff();
      }
    }
  }

  Widget staffList({required bool loadNext}) {
    return CustomListView(
      scrollController: _scrollController,
      items: _viewModel.collectionApiResponse.data!,
      loadNext: loadNext,
      itemBuilder: (BuildContext context, UserModel item) {
        return staffCard(item, (user) async {
          showDialogGeneric(
              context: context,
              dialog: ConfirmationDialog(
                  title: getTranslated("assign_to_staff", context),
                  message:
                      "${getTranslated("assign_to_staff_des", context)} ${user.name!}",
                  confirmed: () async {
                    await _viewModelAssignChild
                        .assignChild(user.id!)
                        .then((value) {
                          selectedStaff=user;
                    });
                  }));
        });
      },
      direction: Axis.vertical,
    );
  }

  Future<void> assignChildResponse() async {
    var status = _viewModelAssignChild.assigningChildResponse.status;

    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.loading,
              title: getTranslated("assign_to_staff", context),
              message:getTranslated("please_waite", context),
              onCompleted: (s) {},
            ));
        await _viewModelAssignChild
            .setAssigningChildResponse(ApiResponse.non());
        break;
      case Status.COMPLETED:
        if(selectedStaff!=null) {
          widget.onAssignCompleted(selectedStaff!);
        }
        Navigator.pop(context);
        await _viewModelAssignChild
            .setAssigningChildResponse(ApiResponse.non())
            .then((value) {
          showAlertDialog(
              context: context,
              messageDialog: ActionDialog(
                type: DialogType.completed,
                title: getTranslated("assign_to_staff", context),
                message: getTranslated("process_finished", context),
                onCompleted: (s) {
                  Navigator.pop(context);
                },
              ));
        });

        break;
      case Status.ERROR:
        Navigator.pop(context);
        var message = _viewModelAssignChild.assigningChildResponse.message;
        await _viewModelAssignChild
            .setAssigningChildResponse(ApiResponse.non())
            .then((value) {
          showAlertDialog(
              context: context,
              messageDialog: ActionDialog(
                type: DialogType.error,
                title: "error",
                message: message.toString(),
                onCompleted: (s) {},
              ));
        });

        break;
      default:
    }
  }
}
