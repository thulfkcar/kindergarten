import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Staff/StaffViewModel.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../data/network/FromData/AssingChildForm.dart';
import '../../../di/Modules.dart';
import '../general_components/ActionDialog.dart';

class AssignScreen extends ConsumerStatefulWidget {
  const AssignScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AssingScreenState();
}

class _AssingScreenState extends ConsumerState<AssignScreen> {
  late StaffViewModel _viewModel;

  final AssignChildForm _assignForm = AssignChildForm();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(staffViewModelProvider);
    Future.delayed(Duration.zero, () async {
      postingResponse();
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Assign Child to",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(),
        ));
  }
  Future<void> showAlertDialog({required ActionDialog messageDialog}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return messageDialog;
      },
    );
  }


  void postingResponse() {
    var status = _viewModel.addingStaffResponse.status;

    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            messageDialog: ActionDialog(
              type: DialogType.loading,
              title: "Adding Child",
              message: "pleas wait until process complete..",
              onCompleted: () {},
            ));
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        showAlertDialog(
            messageDialog: ActionDialog(
              type: DialogType.completed,
              title: "Competed",
              message: "child ${_viewModel.addingStaffResponse.data?.name}",
              onCompleted: () {
                Navigator.pop(context);
              },
            ));
        break;
      case Status.ERROR:
        Navigator.pop(context);
        showAlertDialog(
            messageDialog: ActionDialog(
              type: DialogType.error,
              title: "error",
              message: _viewModel.addingStaffResponse.message.toString(),
              onCompleted: () {},
            ));
        break;
      default:
    }
  }
}
