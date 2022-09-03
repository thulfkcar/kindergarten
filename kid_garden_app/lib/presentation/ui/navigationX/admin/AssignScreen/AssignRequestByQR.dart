import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/admin/AssignScreen/QRReader.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import '../../../../../data/network/ApiResponse.dart';
import '../../../../../di/Modules.dart';
import '../../../childActions/AssignChildViewModel.dart';
import '../../../dialogs/ActionDialog.dart';

class AssignScreenByQR extends ConsumerStatefulWidget {
  final String? childId;
  final Function() onAssignCompleted ;

  const AssignScreenByQR({
    required this.childId,
    required this.onAssignCompleted,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AssignByQRScreenState();

}

class _AssignByQRScreenState extends ConsumerState<AssignScreenByQR> {
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
        title: Text(
          getTranslated("assign_to_staff", context),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Center(
          child: QRReader(
            barcodeResult: (barcode) async {
              if (barcode.code != null) {
                await _viewModelAssignChild.assignChild(barcode.code!);
              }
            },
          ),
        ),
      ),
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
              message: getTranslated("please_waite", context),
              onCompleted: (s) {},
            ));
        await _viewModelAssignChild
            .setAssigningChildResponse(ApiResponse.non());
        break;
      case Status.COMPLETED:
        widget.onAssignCompleted();
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
