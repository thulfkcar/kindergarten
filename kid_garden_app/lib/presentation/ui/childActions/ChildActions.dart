import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:kid_garden_app/presentation/ui/Home/Activities/Activities.dart';
import 'package:kid_garden_app/presentation/ui/childActions/ChildActionViewModel.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:kid_garden_app/repos/ChildRepository.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../domain/ChildAction.dart';
import '../../../providers/Providers.dart';
import '../general_components/ActionGroup.dart';
import '../general_components/ChildActionRow.dart';
import '../general_components/Error.dart';
import '../general_components/MultiSelectChip.dart';
import '../general_components/loading.dart';

class ChildActions extends ConsumerStatefulWidget {
  String? childId;
  //  ChildActions(
  //    this.childId,
  //   Key? key,
  // ) : super(key: key);

  ChildActions({this.childId, Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _ChildActionsState();
}

class _ChildActionsState extends ConsumerState<ChildActions> {
  late ScrollController _scrollController;
  late ChildActionViewModel _viewModel;
  ActionGroup? selectedActionGroup;
  TextEditingController textFieldController = TextEditingController();
  Audience? selectedAudience;
  bool isAddingAction = false;
  List<Audience> audienceList = [
    Audience.All,
    Audience.OnlyMe,
    Audience.Parents,
    Audience.Staff,
  ];
  String description = "";
  List<Audience> selectedAudienceList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()..addListener(getNext);
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(ChildActionViewModelProvider);
    return Scaffold(
      floatingActionButton: selectedActionGroup != null
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  isAddingAction = true;
                });
              })
          : null,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              bodyHead(),
              Expanded(child: body()),
            ],
          ),
          isAddingAction ? addChildActionDialog() : Container(),
          postProgress()
        ],
      ),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            StringResources.of(context)?.getText("child_actions") ?? "Error",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0),
    );
  }

  void getNext() async {
    var state = _viewModel.childActionResponse.status;
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      if (state == Status.COMPLETED && state != Status.LOADING_NEXT_PAGE) {
        await _viewModel.fetchNextChildActions();
      }
    }
  }

  Widget bodyHead() {
    var status = _viewModel.actionGroupResponse.status;
    switch (status) {
      case Status.LOADING:
        return LoadingWidget();
      case Status.COMPLETED:
        return SizedBox(
            height: 90,
            child: ActionGroups(
                actionGroups: _viewModel.actionGroupResponse.data!,
                selectedItem: (value) {
                  setState(() {
                    selectedActionGroup = value;
                  });
                }));
      case Status.ERROR:
        return MyErrorWidget(_viewModel.actionGroupResponse.message!);
      case Status.NON:
        break;
      default:
    }
    return Container(
      height: 1,
    );
  }

  Widget body() {
    var status = _viewModel.childActionResponse.status;
    switch (status) {
      case Status.LOADING:
        return LoadingWidget();
      case Status.COMPLETED:
        return CustomListView(
          scrollController: _scrollController,
          items: _viewModel.childActionResponse.data!,
          loadNext: false,
          itemBuilder: (BuildContext context, ChildAction item) {
            return ChildActionRow(childAction: item);
          },
          direction: Axis.vertical,
        );
      case Status.ERROR:
        return ErrorWidget(_viewModel.childActionResponse.message!);
      case Status.LOADING_NEXT_PAGE:
        return CustomListView(
          scrollController: _scrollController,
          items: _viewModel.childActionResponse.data!,
          loadNext: true,
          itemBuilder: (BuildContext context, ChildAction item) {
            return ChildActionRow(childAction: item);
          },
          direction: Axis.vertical,
        );
      case Status.NON:
        break;
      default:
    }
    return Container();
  }

  Widget addChildActionDialog() {
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
              //todo missing validate before that

              onPressed: () {
                setState(() {
                  isAddingAction = false;
                });

                if (selectedActionGroup != null) {
                  var childAction = ChildAction(
                      id: "",
                      actionGroupId: selectedActionGroup!.id,
                      audience: selectedAudience!,
                      value: textFieldController.text, childId: widget.childId!, userId: '', date: DateTime.now());
                  _viewModel.addChildAction(childAction: childAction);
                  isAddingAction = false;
                }
              },
              child: const Text("Save"),
            )
          ],
        ));
  }

  Widget postProgress() {
    var status = _viewModel.childActionPostResponse.status;
    switch (status) {
      case Status.LOADING:
        return LoadingWidget();
      case Status.COMPLETED:
        _viewModel.appendNewItems([_viewModel.childActionPostResponse.data!]);
        break;
      case Status.ERROR:
        return MyErrorWidget(_viewModel.childActionPostResponse.message!);
      case Status.NON:
        break;
      default:
    }

    return Container();
  }
}
