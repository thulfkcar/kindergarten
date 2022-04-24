import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/di/Modules.dart';
import 'package:kid_garden_app/domain/Kindergraten.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/general_components/ActionDialog.dart';
import 'package:kid_garden_app/presentation/ui/general_components/ConfirmationDialog.dart';
import 'package:kid_garden_app/presentation/ui/general_components/Error.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/kindergartenViewModel.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/requestDialog.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginOrSignUpScreen.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';

import '../../../data/network/ApiResponse.dart';
import '../general_components/CustomListView.dart';
import '../general_components/KindergratenCard.dart';
import '../general_components/loading.dart';
import 'KindergartensView.dart';
import 'LoginDialog.dart';

class KindergartenScreen extends ConsumerStatefulWidget {
  String? childId;

  KindergartenScreen({
    this.childId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _KindergartenScreenState();
}

class _KindergartenScreenState extends ConsumerState<KindergartenScreen> {
  late KindergartenViewModel _viewModel;
  late LoginPageViewModel loginViewModel;
  late ScrollController _scrollController;
  TextEditingController editingController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()..addListener(getNext);
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(kindergartenViewModelProvider);
    loginViewModel = ref.watch(LoginPageViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("kindergarten")),
      bottomSheet: widget.childId == null
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorStyle.male1),
                      elevation: MaterialStateProperty.all(0),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginOrSignUpScreen()));

                      // await showLoginDialog(
                      //     longinDialog: LoginDialog(
                      //       loggedIn: (bool isLoggedIn) {},
                      //     ),
                      //     context: context);
                    },
                  ),
                ),
              ],
            )
          : Container(
              height: 1,
            ),
      body: Column(
        children: [
          head(),
          Expanded(child: KindergartensView(childId: widget.childId))
        ],
      ),
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
        decoration: const InputDecoration(
            labelText: "Search",
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }

  Widget body() {
    var status = _viewModel.kindergartenApiResponse.status;

    switch (status) {
      case Status.LOADING:
        return LoadingWidget();

      case Status.COMPLETED:
        return CustomListView(
            scrollController: _scrollController,
            items: _viewModel.kindergartenApiResponse.data!,
            loadNext: false,
            itemBuilder: (BuildContext context, Kindergraten item) {
              return kinderCard(item);
            },
            direction: Axis.vertical);
      case Status.ERROR:
        return MyErrorWidget(
            msg: _viewModel.kindergartenApiResponse.message ?? "Error");

      case Status.LOADING_NEXT_PAGE:
        return CustomListView(
            scrollController: _scrollController,
            items: _viewModel.kindergartenApiResponse.data!,
            loadNext: true,
            itemBuilder: (BuildContext context, Kindergraten item) {
              return kinderCard(item);
            },
            direction: Axis.vertical);

      case Status.NON:
        return Container();
      default:
    }
    return Container();
  }

  void getNext() async {
    var state = _viewModel.kindergartenApiResponse.status;
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      if (state == Status.COMPLETED && state != Status.LOADING_NEXT_PAGE) {
        await _viewModel.fetchNextKindergarten();
      }
    }
  }

  Widget kinderCard(Kindergraten item) {
    return KindergartenCard(
      kindergraten: item,
      addRequestEnable: widget.childId != null ? true : false,
      onAddRequestClicked: (id) {

      },
    );
  }
}
