import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import '../../../domain/ActionGroup.dart';
import '../../../domain/ChildAction.dart';
import '../general_components/MultiSelectChip.dart';

class AddChildActionDialog extends ConsumerStatefulWidget {
  List<Audience> audienceList = [
    Audience.All,
    Audience.OnlyMe,
    Audience.Parents,
    Audience.Staff,
  ];
  ActionGroup selectedActionGroup;

  bool isAddingAction = false;
  String childId;
  Function(bool) onDismiss;
  Function(ChildAction,List<File>?) addChild;

  List<File>? medias;

  AddChildActionDialog(
      {required this.addChild,
      required  this.selectedActionGroup,
      required this.onDismiss,
     required this.childId,
      Key? key})
      : super(key: key);

  @override
  ConsumerState createState() => _AddChildActionDialogState();

}

class _AddChildActionDialogState extends ConsumerState<AddChildActionDialog> {
  TextEditingController textFieldController = TextEditingController();
  Audience? selectedAudience;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        child: AlertDialog(
          title: (Text(AppLocalizations.of(context)?.getText("adding_action")??"Adding Action")),
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
                        hintText: "playing with other children",
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
                          selectedAudience = selectedList.first;
                        },
                      );
                    },
                    maxSelection: 1,
                  ),
                  TextButton(
                      onPressed: () {
                        picImage();
                      },
                      child:  Text(
                       AppLocalizations.of(context)?.getText("choose_image")?? 'Choose images',
                        style: const TextStyle(color: Colors.blue),
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
                  widget.isAddingAction = false;/**/
                });
              },
              child:  Text(AppLocalizations.of(context)?.getText("cancel")??"Cancel"),
            ),
            TextButton(
              //todo missing validate before that

              onPressed: () {

                var childAction = ChildAction(
                    id: "",
                    actionGroupId: widget.selectedActionGroup.id,
                    audience: selectedAudience!,
                    value: textFieldController.text,
                    childId: widget.childId,
                    userId: '',
                    date: DateTime.now());
                widget.addChild(childAction,widget.medias);
                widget.isAddingAction = false;
                widget.onDismiss(false);
              },
              child:  Text(AppLocalizations.of(context)?.getText("save")??"Save"),
            )
          ],
        ));
  }

  Future<void> picImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,type:FileType.image );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      widget.medias=files;
    } else {
      // User canceled the picker
    }


  }
}
