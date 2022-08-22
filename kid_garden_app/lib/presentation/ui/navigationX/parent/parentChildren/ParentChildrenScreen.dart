import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/general_components/loading.dart';
import 'package:kid_garden_app/presentation/general_components/units/floating_action_button.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildAddingScreen.dart';
import 'package:kid_garden_app/presentation/ui/Child/childProfileScreen/ChildProfileScreen.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/ActionDialog.dart';
import 'package:kid_garden_app/presentation/general_components/Error.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import '../../../../../data/network/ApiResponse.dart';
import '../../../../../di/Modules.dart';
import '../../../../../domain/Child.dart';
import '../../../../general_components/ParentChildCardGrid.dart';
import 'ParentChildrenViewModel.dart';

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
  TextEditingController editingController = TextEditingController();
  bool isParent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(parentChildrenViewModelProvider);

    setState(() {
      AsyncValue<UserModel?> user = ref.watch(userProvider);

      user.whenOrNull(data: (user) {
        user!.role == Role.Parents ? isParent = true : isParent = false;
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
                            if (child != null) {
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
        decoration: InputDecoration(
            labelText: getTranslated("search", context),
            hintText: getTranslated("type_to_search", context),
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)))),
      ),
    );
  }

  Widget body() {
    var status = _viewModel.collectionApiResponse.status;

    switch (status) {
      case Status.LOADING:
        return LoadingWidget();

      case Status.COMPLETED:
        return childrenGrid();
      case Status.ERROR:
        return MyErrorWidget(
            msg: _viewModel.collectionApiResponse.message ?? "Error");

      case Status.LOADING_NEXT_PAGE:
        return childrenGrid();

      case Status.Empty:
        return EmptyWidget(
            msg: AppLocalizations.of(context)?.getText("no_children") ??
                _viewModel.collectionApiResponse.message ??
                "Error");
      case Status.NON:
        return Container();
      default:
    }
    return Container();
  }

  Future<void> addingRequestState() async {
    var status = _viewModel.joinKindergartenRequest.status;

    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.loading,
              title: AppLocalizations.of(context)?.getText("join_request") ??
                  "Request Dialog",
              message:
                  AppLocalizations.of(context)?.getText("join_request_des") ??
                      "Requesting the Kindergarten for joining your child in",
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
                title: AppLocalizations.of(context)?.getText("join_request") ??
                    "Request Dialog",
                message: AppLocalizations.of(context)
                        ?.getText("join_request_des_comp") ??
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

  childrenGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      children:
          List.generate(_viewModel.collectionApiResponse.data!.length, (index) {
        Child child = _viewModel.collectionApiResponse.data![index];
        return Padding(
            padding: const EdgeInsets.all(8),
            child: ParentChildCardGrid(
                size: 200,
                onClicked: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => ChildProfileScreen(
                                isSubscriptionValid: widget.isSubscriptionValid,
                                subscriptionMessage: widget.subscriptionMessage,
                                child: child,
                              )));
                },
                child: child));
      }, growable: false),
    );
  }
}