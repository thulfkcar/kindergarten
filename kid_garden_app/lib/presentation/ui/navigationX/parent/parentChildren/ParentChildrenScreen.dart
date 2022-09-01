import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/general_components/loading.dart';
import 'package:kid_garden_app/presentation/general_components/units/floating_action_button.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildAddingScreen.dart';
import 'package:kid_garden_app/presentation/ui/Child/childProfileScreen/ChildProfileScreen.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/ActionDialog.dart';
import 'package:kid_garden_app/presentation/general_components/Error.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import '../../../../../data/network/ApiResponse.dart';
import '../../../../../di/Modules.dart';
import '../../../../../domain/Child.dart';
import '../../../../general_components/ParentChildCardGrid.dart';
import 'ParentChildrenViewModel.dart';

class ParentChildrenScreen extends ConsumerStatefulWidget {
 final bool isSubscriptionValid;
 final String? subscriptionMessage;

  const ParentChildrenScreen({Key? key,
    this.subscriptionMessage,
    required this.isSubscriptionValid,
  }) : super(key: key) ;

  @override
  ConsumerState createState() => _ParentChildrenScreenState();
}

class _ParentChildrenScreenState extends ConsumerState<ParentChildrenScreen> {
  late ParentChildrenViewModel _viewModel;
  TextEditingController editingController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(parentChildrenViewModelProvider);



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
          Expanded(child: body())
        ],
      ),
      floatingActionButton: floatingActionButtonAdd22(onClicked: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChildAddingScreen(onAdded: (child) {
                            if (child != null) {
                              _viewModel.addNewItemToCollection(child);
                            }
                          })));
            })
      ,
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
            msg: _viewModel.collectionApiResponse.message ?? "Error",onRefresh: (){
          _viewModel.fetchChildren();
        },);

      case Status.LOADING_NEXT_PAGE:
        return childrenGrid();

      case Status.Empty:
        return EmptyWidget(msg: getTranslated("no_children", context),onRefresh: (){
          _viewModel.fetchChildren();
        },);
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
              title: getTranslated("join_request", context),
              message: getTranslated("join_request_des", context),
              onCompleted: (d) {
                //todo:solve this shit for the sake of future projects
              },
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
                title: getTranslated("join_request", context),
                message: getTranslated("join_request_des_comp", context),
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
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 5;
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / itemHeight),
      controller: ScrollController(keepScrollOffset: false),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children:
          List.generate(_viewModel.collectionApiResponse.data!.length, (index) {
        Child child = _viewModel.collectionApiResponse.data![index];
        return Padding(
            padding: const EdgeInsets.all(8),
            child: ParentChildCardGrid(
              height: itemHeight,
                onClicked: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => ChildProfileScreen(
                                isSubscriptionValid: widget.isSubscriptionValid,
                                subscriptionMessage: widget.subscriptionMessage,
                                onChildRemoved: () { _viewModel.removeItemFromCollection( _viewModel.collectionApiResponse.data![index]); },
                                child: child,
                              )));
                },
                child: child));
      }, growable: false),
    );
  }
}
