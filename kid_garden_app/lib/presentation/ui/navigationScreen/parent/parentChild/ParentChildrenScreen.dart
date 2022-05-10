import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildAddingScreen.dart';
import 'package:kid_garden_app/presentation/ui/general_components/ActionDialog.dart';
import 'package:kid_garden_app/presentation/ui/general_components/Error.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/kindergartenScreen.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationScreen/parent/parentChild/ParentChildrenViewModel.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import '../../../../../data/network/ApiResponse.dart';
import '../../../../../di/Modules.dart';
import '../../../../../domain/Child.dart';
import '../../../general_components/CustomListView.dart';
import '../../../general_components/ParentChildRow.dart';
import '../../../general_components/loading.dart';
import '../../../general_components/units/floating_action_button.dart';

class ParentChildrenScreen extends ConsumerStatefulWidget {
  bool fromProfile;
  bool isSubscriptionValid;
  String? subscriptionMessage;

  ParentChildrenScreen({
    this.subscriptionMessage,
    required this.isSubscriptionValid,
    required this.fromProfile,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ParentChildrenScreenState();
}

class _ParentChildrenScreenState extends ConsumerState<ParentChildrenScreen> {
  late ParentChildrenViewModel _viewModel;
  late LoginPageViewModel _viewModel_login;
  TextEditingController editingController = TextEditingController();
  bool isParent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    _viewModel = ref.watch(parentChildrenViewModelProvider);
    _viewModel_login = ref.watch(LoginPageViewModelProvider);
    _viewModel_login.getUserChanges().then((value) {
      setState(() {
        value?.role == Role.Parents ? isParent = true : isParent = false;
      });
    });
    Future.delayed(Duration.zero, () async {
      await addingRequestState();
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.purple.withOpacity(0.3),
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(

      body: Column(
        children: [
          isParent != true
              ? (widget.fromProfile ? head() : Container())
              : Container(),
          Expanded(child: body())
        ],
      ),
      floatingActionButton: widget.fromProfile
          ? floatingActionButtonAdd22(onClicked: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChildAddingScreen(onAdded: (child) {
                        if(child!=null) {
                          _viewModel.appendNewItems([child]);
                        }
                          })));
            })
          : null,
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          _viewModel.search(value);
        },
        controller: editingController,
        cursorColor: ColorStyle.female1,
        decoration: const InputDecoration(
            labelText: "Search",
            hintText: "Typing to search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)))),
      ),
    );
  }

  Widget body() {
    var status = _viewModel.childListResponse.status;

    switch (status) {
      case Status.LOADING:
        return LoadingWidget();

      case Status.COMPLETED:
        return CustomListView(
            items: _viewModel.childListResponse.data!,
            loadNext: false,
            itemBuilder: (BuildContext context, Child item) {
              return childNavigation(item);
            },
            direction: Axis.vertical, scrollController: ScrollController(),);
      case Status.ERROR:
        return MyErrorWidget(
            msg: _viewModel.childListResponse.message ?? "Error");

      case Status.LOADING_NEXT_PAGE:
        return CustomListView(
            items: _viewModel.childListResponse.data!,
            loadNext: true,
            itemBuilder: (BuildContext context, Child item) {
              return childNavigation(item);
            },
            direction: Axis.vertical, scrollController: ScrollController(),);

      case Status.Empty:
        return EmptyWidget(
            msg: AppLocalizations.of(context)?.getText("no_children")?? _viewModel.childListResponse.message ?? "Error");
      case Status.NON:
        return Container();
      default:
    }
    return Container();
  }


  Widget childNavigation(Child item) {
    return ParentChildCard(
        onClicked: (child) {
          if (!widget.isSubscriptionValid) Navigator.pop(context);
        },
        onJoinKindergartenClicked: (childId) async {
          await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          KindergartenScreen(childId: item.id)))
              .then((value) async {
            await _viewModel.joinRequest(childId);
          });

          // request if result not null
        },
        onKindergartenClicked: (kindergartenId) {
          showAlertDialog(
              context: context,
              messageDialog: ActionDialog(
                  type: DialogType.warning,
                  title: "kinder Clicked",
                  message: "sdfdssd"));
        },
        onChildActionsClicked: (childId) {
          if (!widget.isSubscriptionValid) Navigator.pop(context);
        },
        child: item);
  }

  Future<void> addingRequestState() async {
    var status = _viewModel.joinKindergartenRequest.status;

    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.loading,
              title: "Request Dialog",
              message: "Requesting the Kindergarten for joining your child in",
              onCompleted: (d) {},
            ));
        await _viewModel.setJoinKindergartenRequest(ApiResponse.non());
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        await _viewModel
            .setJoinKindergartenRequest(ApiResponse.non())
            .then((value) async {
          await showAlertDialog(
              context: context,
              messageDialog: ActionDialog(
                type: DialogType.completed,
                title: "Request Dialog",
                message:
                    "Requesting the Kindergarten completed , your request in pending...",
                onCompleted: (s) async {
                  await _viewModel.fetchChildren();
                  await _viewModel
                      .setJoinKindergartenRequest(ApiResponse.non());
                },
              ));
        });

        break;
      case Status.ERROR:
        var message = _viewModel.joinKindergartenRequest.message;
        Navigator.pop(context);
        await _viewModel
            .setJoinKindergartenRequest(ApiResponse.non())
            .then((value) async {
          await showAlertDialog(
              context: context,
              messageDialog: ActionDialog(
                type: DialogType.error,
                title: "error while requesting",
                message: message.toString(),
                onCompleted: (s) async {
                  await _viewModel.fetchChildren();
                  await _viewModel
                      .setJoinKindergartenRequest(ApiResponse.non());
                },
              ));
        });

        break;

      default:
    }
  }
}
