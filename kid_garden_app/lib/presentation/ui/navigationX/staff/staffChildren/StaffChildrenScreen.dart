import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/Child/childProfileScreen/ChildProfileScreen.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/staff/staffChildren/StaffChildrenViewModel.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';

import '../../../../../data/network/ApiResponse.dart';
import '../../../../../di/Modules.dart';
import '../../../../../domain/Child.dart';
import '../../../../general_components/ChildRow.dart';
import '../../../../general_components/CustomListView.dart';
import '../../../../general_components/Error.dart';
import '../../../../general_components/loading.dart';
import '../../../../styles/colors_style.dart';
import '../../../login/LoginPageViewModel.dart';

class StaffChildrenScreen extends ConsumerStatefulWidget {
  String? subUserId;
  TextEditingController editingController = TextEditingController();

  StaffChildrenScreen({
    this.subUserId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _StaffChildrenScreenState();
}

class _StaffChildrenScreenState extends ConsumerState<StaffChildrenScreen> {
  late ScrollController _scrollController;
  late StaffChildrenViewModel _viewModel;
  late LoginPageViewModel _viewModel_login;
  TextEditingController editingController = TextEditingController();
  bool isParent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()..addListener(getNext);
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(staffChildrenViewModelProvider);
    _viewModel_login = ref.watch(LoginPageViewModelProvider);
    return Scaffold(
      body:body());
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
            hintText: getTranslated("search", context),
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
       return children(false);
      case Status.ERROR:
        return MyErrorWidget(
            msg: _viewModel.collectionApiResponse.message ?? "Error",onRefresh: (){
          _viewModel.fetchChildren();
        },);

      case Status.LOADING_NEXT_PAGE:
        return children(true);

      case Status.Empty:
        return EmptyWidget(
          msg: getTranslated("no_children", context),
          onRefresh: () {
            _viewModel.fetchChildren();
          },
        );
      case Status.NON:
        return Container();
      default:
    }
    return Container();
  }

  void getNext() async {
    var state = _viewModel.collectionApiResponse.status;
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      if (state == Status.COMPLETED && state != Status.LOADING_NEXT_PAGE) {
        await _viewModel.fetchNextChildren();
      }
    }
  }

  Widget children(bool loadNext ) {
     return CustomListView(
        scrollController: _scrollController,
        items: _viewModel.collectionApiResponse.data!,
        loadNext: loadNext,
        itemBuilder: (BuildContext context, Child item) {
          return ChildRow( onChildClicked: () { Navigator.push(context, MaterialPageRoute(builder: (builder)=>ChildProfileScreen(child: item, isSubscriptionValid: true))); },
              child: item);
        },
        direction: Axis.vertical);
  }
}
