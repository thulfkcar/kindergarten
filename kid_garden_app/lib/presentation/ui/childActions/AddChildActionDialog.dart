import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/ActionGroup.dart';
import '../../../domain/ChildAction.dart';
import '../general_components/MultiSelectChip.dart';
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
  Function(ChildAction,List<AssetEntity>?) addChild;

  List<AssetEntity>? medias;

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


    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        child: AlertDialog(
          title: (Text("Adding Action")),
          content: Container(

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
                  TextButton(
                      onPressed: () {
                        picImage();
                      },
                      child: const Text(
                        'Choose images',
                        style: TextStyle(color: Colors.blue),
                      )),

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
                widget.addChild(childAction,widget.medias);
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
    widget.medias=assets;

  }
}
