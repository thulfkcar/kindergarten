import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:kid_garden_app/presentation/general_components/ActionGroup.dart';
import 'package:kid_garden_app/presentation/general_components/CustomListView.dart';
import 'package:kid_garden_app/presentation/general_components/Error.dart';
import 'package:kid_garden_app/presentation/general_components/loading.dart';
import 'package:kid_garden_app/presentation/general_components/units/cards.dart';
import 'package:kid_garden_app/presentation/ui/childActions/ChildActionViewModel.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../di/Modules.dart';
import '../../../domain/ChildAction.dart';
import '../AssingScreen/AssginScreen.dart';
import '../dialogs/ActionDialog.dart';

import 'ChildActionAddScreen.dart';

class ChildActions extends ConsumerStatefulWidget {
  String childId;

  //  ChildActions(
  //    this.childId,
  //   Key? key,
  // ) : super(key: key);

  ChildActions({required this.childId, Key? key}) : super(key: key);

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
    _viewModel = ref.watch(ChildActionViewModelProvider(widget.childId));
    Future.delayed(Duration.zero, () async {
      postingChildActionResponse();
    });
    return Scaffold(
      floatingActionButton:
      // selectedActionGroup != null
      //     ?
      FloatingActionButton(
              child: const Icon(Icons.add),
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder)=>ChildActionAddScreen(childId: widget.childId,)));
                // setState(() {
                //   isAddingAction = true;
                // });
              }),
          // : null,
      body: body(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          AppLocalizations.of(context)?.getText("child_actions") ??
              "Child Actions",
          style: const TextStyle(color: Colors.black),
        ),
        elevation: 0,
        actions: [
          ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AssignScreen(childId: widget.childId)));
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
            return action4ImgCard(ScrollController(), item);
          },
          direction: Axis.vertical,
        );
      case Status.Empty:
        return EmptyWidget(msg: getTranslated("noActionsForChild", context),onRefresh: (){
          _viewModel.fetchChildActions();
        },);
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
            return action4ImgCard(ScrollController(), item);
          },
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
              title: AppLocalizations.of(context)?.getText("adding_action") ??
                  "Adding Action",
              message:
                  AppLocalizations.of(context)?.getText("adding_action_des") ??
                      "please wait until process complete..",
              onCompleted: (s) {},
            ));
        _viewModel.setChildActionPostResponse(ApiResponse.non());
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.completed,
              title: AppLocalizations.of(context)?.getText("adding_action") ??
                  "Adding Action",
              message:
                  "action ${_viewModel.childActionPostResponse.data?.actionGroupName} is added.",
              onCompleted: (s) {
                _viewModel.setChildActionPostResponse(ApiResponse.non());
              },
            ));
        _viewModel.setChildActionPostResponse(ApiResponse.non());
        break;
      case Status.ERROR:
        Navigator.pop(context);
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.error,
              title: AppLocalizations.of(context)?.getText("adding_action") ??
                  "Adding Action",
              message: _viewModel.childActionPostResponse.message.toString(),
              onCompleted: (s) {},
            ));
        _viewModel.setChildActionPostResponse(ApiResponse.non());
        break;
      default:
    }
  }
}
