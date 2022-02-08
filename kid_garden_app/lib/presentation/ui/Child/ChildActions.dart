import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:kid_garden_app/domain/Action.dart';
import 'package:kid_garden_app/network/OnCompleteListner.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

import '../../../domain/ChildAction.dart';
import '../genral_components/ActionGroup.dart';
import '../genral_components/ChildActionRow.dart';
import '../genral_components/MultiSelectChip.dart';

class ChildActions extends StatefulWidget {
  String childId;

  ChildActions({Key? key, required this.childId}) : super(key: key);

  @override
  _ChildActionsState createState() => _ChildActionsState();
}

class _ChildActionsState extends State<ChildActions>
    implements OnCompleteListener {
  ChildRepository childRepo = ChildRepository();
  var isAddingAction = false;
  List<ChildAction>? childActions = [];
  Audience selectedAudience = Audience.OnlyMe;
  List<ActionGroup> actionGroups = [];
  ActionGroup? selectedActionGroup = null;

  var textFieldController=TextEditingController();

  @override
  void initState() {
    childRepo.getActionsGroups(onCompleteListener: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Audience> audienceList = [
      Audience.All,
      Audience.OnlyMe,
      Audience.Parents,
      Audience.Staff,
    ];
    String description = "";

    List<Audience> selectedAudienceList = [];
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(top: 60),
              child: SizedBox(
                height: 65,
                width: double.maxFinite,
                child: ActionGroups(
                  actionGroups: actionGroups,
                  selectedIndex: (index) {
                    print(index.name);
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: childActions?.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChildActionRow(childAction: childActions![index]);
                },
              ),
            )
          ],
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: FloatingActionButton(
            onPressed: () {
              setState(() => isAddingAction = true);
            },
            child: Icon(Icons.add),
          ),
        ),
        if (isAddingAction)
          addChildActionDialog(
              audienceList: audienceList,
              actionGroups: actionGroups,
              selectedAudienceList: selectedAudienceList,
              description: description)
      ],
    );
  }

  void addAction(ChildAction childAction) {
    setState(() {
      childActions?.add(childAction);
      isAddingAction = false;
    });
  }

  Widget addChildActionDialog(
      {required List<ActionGroup> actionGroups,
      required List<Audience> audienceList,
      required List<Audience> selectedAudienceList,
      required String description}) {
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
                  SizedBox(
                    height: 65,
                    width: double.maxFinite,
                    child: ActionGroups(
                      actionGroups: actionGroups,
                      selectedIndex: (group) {
                        selectedActionGroup = group;
                      },
                    ),
                  ),
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
                    audienceList,
                    onSelectionChanged: (selectedList) {
                      setState(
                        () {
                          selectedAudience = selectedList.first;
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
                setState(() => isAddingAction = false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                var childAction = ChildAction(
                    id: "",
                    actionGroupId: selectedActionGroup!.id,
                    audience: selectedAudience,
                    value: textFieldController.text, actionGroup: selectedActionGroup!);
                childRepo.addChildAction(
                    childAction: childAction, onCompleteListener: this);
                isAddingAction = false;
              },
              child: const Text("Save"),
            )
          ],
        ));
  }


  @override
  void onError(String error) {
    print(error);
  }

  @override
  void onCompleted(t) {
    if (t.runtimeType == ChildAction) {
      addAction(t);
    } else if (t.runtimeType == List<ActionGroup>) {
      actionGroups = t as List<ActionGroup>;
    }
  }
}


