import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/data/network/FromData/AssingChildForm.dart';
import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:kid_garden_app/presentation/ui/childActions/AssignChildViewModel.dart';
import 'package:kid_garden_app/presentation/ui/childActions/ChildActionViewModel.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../di/Modules.dart';
import '../../../domain/ChildAction.dart';
import '../AssingScreen/AssginScreen.dart';
import '../general_components/ActionDialog.dart';
import '../general_components/ActionGroup.dart';
import '../general_components/CustomListView.dart';
import '../general_components/Error.dart';
import '../general_components/loading.dart';
import '../general_components/units/cards.dart';
import 'AddChildActionDialog.dart';

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
    _viewModel = ref.watch(ChildActionViewModelProvider(widget.childId!));
    Future.delayed(Duration.zero, () async {
      postingChildActionResponse();
    });
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
          isAddingAction
              ? AddChildActionDialog(
                  selectedActionGroup: selectedActionGroup!,
                  childId: widget.childId!,
                  addChild: (value, assets) {
                    setState(() {
                      _viewModel.addChildAction(
                          childAction: value, assets: assets);
                    });
                  },
                  onDismiss: (value) {
                    setState(() {
                      isAddingAction = value;
                    });
                  },
                )
              : Container(),
          //postProgress()
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          StringResources.of(context)?.getText("child_actions") ?? "Error",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        actions: [
          ElevatedButton(
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AssignScreen(childId:widget.childId)));

              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0)),
              child: const Icon(FontAwesomeIcons.link))
        ],
      ),
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
        return MyErrorWidget(msg: _viewModel.actionGroupResponse.message!);
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
            return action4ImgCard(ScrollController(),item);          },
          direction: Axis.vertical,
        );
      case Status.ERROR:
        return MyErrorWidget(
          msg: _viewModel.childActionResponse.message!,
          onRefresh: () {
            _viewModel.fetchChildActions();
          },
        );
      case Status.LOADING_NEXT_PAGE:
        return CustomListView(
          scrollController: _scrollController,
          items: _viewModel.childActionResponse.data!,
          loadNext: true,
          itemBuilder: (BuildContext context, ChildAction item) {
            return action4ImgCard(ScrollController(),item);          },
          direction: Axis.vertical,
        );
      case Status.NON:
        break;
      default:
    }
    return Container();
  }

  void postingChildActionResponse() {
    var status = _viewModel.childActionPostResponse.status;

    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            context: context,
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
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.completed,
              title: "Competed",
              message:
                  "action ${_viewModel.childActionPostResponse.data?.actionGroupName} is added.",
              onCompleted: () {
                _viewModel.setChildActionPostResponse(ApiResponse.non());
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
              message: _viewModel.childActionPostResponse.message.toString(),
              onCompleted: () {},
            ));
        break;
      default:
    }
  }

}
