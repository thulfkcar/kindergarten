import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/ActionGroup.dart';
import '../../../domain/ChildAction.dart';
import '../general_components/MultiSelectChip.dart';
import 'ChildActionViewModel.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddChildActionDialog extends ConsumerStatefulWidget {
  List<Audience> audienceList = [
    Audience.All,
    Audience.OnlyMe,
    Audience.Parents,
    Audience.Staff,
  ];
  ActionGroup selectedActionGroup;

  List<Audience> selectedAudienceList = [];
  Audience? selectedAudience;
  bool isAddingAction = false;
  String childId;
  Function(bool) onDismiss;
  Function(ChildAction) addChild;

  AddChildActionDialog(
      {required this.addChild,
      required  this.selectedActionGroup,
      this.selectedAudience,
      required this.onDismiss,
     required this.childId,
      Key? key})
      : super(key: key);

  @override
  ConsumerState createState() => _AddChildActionDialogState();

}

class _AddChildActionDialogState extends ConsumerState<AddChildActionDialog> {
  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    picImage();

    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 80, 0, 0),
        child: AlertDialog(
          title: (Text("Adding Action")),
          content: Container(
            height: 500,
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextField(
                      controller: textFieldController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color(0xFF898989),
                              style: BorderStyle.none,
                            )),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        hintText: "bsdfg dfg sdfg dh sdghft",
                      ),
                      maxLines: 6,
                      minLines: 4,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,

                            // minTime: DateTime(2018, 3, 5),
                            // maxTime: DateTime(2019, 6, 7),
                            onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          print('confirm $date');
                          DatePicker.showTime12hPicker(
                            context,
                            onChanged: (time) {
                              print('change $time');
                            },
                            onConfirm: (time) {
                              print('change $time');
                            },
                          );
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: const Text(
                        'Choose Time Of Action',
                        style: TextStyle(color: Colors.blue),
                      )),
                  MultiSelectChip(
                    widget.audienceList,
                    onSelectionChanged: (selectedList) {
                      setState(
                        () {
                          widget.selectedAudience = selectedList.first;
                        },
                      );
                    },
                    maxSelection: 1,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.onDismiss(false);
                  widget.isAddingAction = false;
                });
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              //todo missing validate before that

              onPressed: () {

                var childAction = ChildAction(
                    id: "",
                    actionGroupId: widget.selectedActionGroup.id,
                    audience: widget.selectedAudience!,
                    value: textFieldController.text,
                    childId: widget.childId,
                    userId: '',
                    date: DateTime.now());
                widget.addChild(childAction);
                widget.isAddingAction = false;
                widget.onDismiss(false);
              },
              child: const Text("Save"),
            )
          ],
        ));
  }

  Future<void> picImage() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(context);

  }
}
