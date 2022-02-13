import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:kid_garden_app/network/OnCompleteListner.dart';
import 'package:kid_garden_app/presentation/ui/childActions/ChildActionViewModel.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';

import '../../../domain/ChildAction.dart';
import '../../../network/ApiResponse.dart';
import '../../../providers/Providers.dart';
import '../genral_components/ActionGroup.dart';
import '../genral_components/ChildActionRow.dart';
import '../genral_components/Error.dart';
import '../genral_components/MultiSelectChip.dart';
import '../genral_components/loading.dart';

class ChildActions extends StatefulWidget {
  String childId;

  ChildActions({Key? key, required this.childId}) : super(key: key);

  @override
  _ChildActionsState createState() => _ChildActionsState();
}

class _ChildActionsState extends State<ChildActions> {
  ChildRepository childRepo = ChildRepository();
  var isAddingAction = false;
  List<ChildAction>? childActions = [];
  Audience selectedAudience = Audience.OnlyMe;
  List<ActionGroup> actionGroups = [];
  ActionGroup? selectedActionGroup = null;

  var textFieldController = TextEditingController();
  ChildActionViewModel viewModel = ChildActionViewModel();

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
    return Scaffold(
      appBar: AppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final childActions = ref.watch(ChildActionViewModelProvider);
          switch (childActions.childActionResponse.status) {
            case Status.LOADING:
              print("thug :: LOADING");
              return LoadingWidget();
            case Status.ERROR:
              print("thug :: ERROR");
              return MyErrorWidget(
                  viewModel.childActionResponse.message ?? "NA");
            case Status.COMPLETED:
              print("thug :: COMPLETED");
              return childActionListView(
                  childActions: viewModel.childActionResponse.data!,
                  audienceList: audienceList,
                  selectedAudienceList: selectedAudienceList,
                  description: description);
            default:
          }

          return Container();
        },
      ),
    );
  }

  Widget childActionListView(
      {required List<ChildAction> childActions,
      required List<Audience> audienceList,
      required List<Audience> selectedAudienceList,
      required String description}) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(top: 60),
              child: SizedBox(
                  height: 65,
                  width: double.maxFinite,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final viewModel = ref.watch(ChildActionViewModelProvider);

                      switch (viewModel.actionGroupResponse.status) {
                        case Status.LOADING:
                          print("thug :: LOADING");
                          return LoadingWidget();
                        case Status.ERROR:
                          print("thug :: ERROR");
                          return MyErrorWidget(
                              viewModel.actionGroupResponse.message ?? "NA");
                        case Status.COMPLETED:
                          print("thug :: COMPLETED");
                          return ActionGroups(
                            actionGroups: viewModel.actionGroupResponse.data!,
                            selectedItem: (item) {
                              viewModel.setSelectedActionGroupId(item.id);
                            },
                          );
                        default:
                      }
                      return Container();
                    },
                  )

                  // ActionGroups(
                  // actionGroups: actionGroups,
                  // selectedIndex: (index) {
                  // print(index.name);
                  // },
                  // ),
                  ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: childActions.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChildActionRow(childAction: childActions[index]);
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
      {required List<Audience> audienceList,
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
              //validate selections

              onPressed: () {
                if (viewModel.selectedActionGroupId != null) {
                  var childAction = ChildAction(
                      id: "",
                      actionGroupId: viewModel.selectedActionGroupId!,
                      audience: selectedAudience,
                      value: textFieldController.text);
                  viewModel.addChildAction(childAction: childAction);
                  isAddingAction = false;
                }
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
