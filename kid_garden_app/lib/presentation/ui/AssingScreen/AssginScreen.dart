import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/AssingScreen/QRReader.dart';
import 'package:kid_garden_app/presentation/ui/Staff/StaffViewModel.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../data/network/FromData/AssingChildForm.dart';
import '../../../di/Modules.dart';
import '../childActions/AssignChildViewModel.dart';
import '../general_components/ActionDialog.dart';

class AssignScreen extends ConsumerStatefulWidget {
  String? childId;

  AssignScreen({
    required this.childId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AssingScreenState();
}

class _AssingScreenState extends ConsumerState<AssignScreen> {
  ScrollController scrollController = ScrollController();
  late AssignChildViewModel _viewModelAssignChild;

  @override
  Widget build(BuildContext context) {
    _viewModelAssignChild =
        ref.watch(assignChildViewModelProvider(widget.childId!));

    Future.delayed(Duration.zero, () async {
      assignChildResponse();
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
        child: Center(
          child: Container(
            child: QRReader(
              barcodeResult: (Barcode) async {
                if (Barcode.code != null) {
                  await _viewModelAssignChild.assignChild(Barcode.code!);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void assignChildResponse() {
    var status = _viewModelAssignChild.assigningChildResponse.status;

    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.loading,
              title: "Assigning Child",
              message: "pleas wait until process complete..",
              onCompleted: () {},
            ));
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.completed,
              title: "Competed",
              message: "assign completed.",
              onCompleted: () {
                _viewModelAssignChild
                    .setAssigningChildResponse(ApiResponse.non());
                Navigator.pop(context);
              },
            ));
        break;
      case Status.ERROR:
        Navigator.pop(context);
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.error,
              title: "error",
              message: _viewModelAssignChild.assigningChildResponse.message
                  .toString(),
              onCompleted: () {
                Navigator.pop(context);
              },
            ));
        break;
      default:
    }
  }
}
