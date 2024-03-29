import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/general_components/ChildRow.dart';
import 'package:kid_garden_app/presentation/general_components/CustomListView.dart';
import 'package:kid_garden_app/presentation/general_components/Error.dart';
import 'package:kid_garden_app/presentation/general_components/loading.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildViewModel.dart';
import 'package:kid_garden_app/presentation/ui/Child/childProfileScreen/ChildProfileScreen.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../di/Modules.dart';
import '../../../domain/Child.dart';
import '../../utile/language_constrants.dart';

class ChildrenExplorer extends ConsumerStatefulWidget {
  String? subUserId;

  ChildrenExplorer({
    this.subUserId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ChildrenExplorerState();
}

class _ChildrenExplorerState extends ConsumerState<ChildrenExplorer> {
  late ScrollController _scrollController;
  late ChildViewModel _viewModel;
  late LoginPageViewModel _viewModel_login;
  TextEditingController editingController = TextEditingController();
  bool isParent = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()
      ..addListener(getNext);
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(childViewModelProvider(widget.subUserId));
    _viewModel_login = ref.watch(LoginPageViewModelProvider);

    var user=  ref.read(hiveProvider).value!.getUser();
        setState(() {
          if(user!=null){
          user.role == Role.Parents ? isParent = true : isParent = false;}
        });
    return Scaffold(
      appBar: AppBar(title: Text(getTranslated("children", context)),backgroundColor: Colors.transparent,elevation: 0,),

      body: Column(
        children: [
         head(),
          Expanded(child: body())
        ],
      ),
      // floatingActionButton: widget.fromProfile
      //     ? floatingActionButtonAdd22(onClicked: () {
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => ChildAddingScreen()));
      //       })
      //     : null,
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
            labelText: AppLocalizations.of(context)?.getText("search") ??
                "Search",
            hintText: AppLocalizations.of(context)?.getText("search") ??
                "Search" "Typing to search",
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
            msg: _viewModel.collectionApiResponse.message ?? "Error",onRefresh: ()async {
          await _viewModel.fetchChildren();
        });

      case Status.LOADING_NEXT_PAGE:
        return children(true);
      case Status.Empty:
        return EmptyWidget(msg: getTranslated("no_children", context),onRefresh: ()async {
          await _viewModel.fetchChildren();
        },);

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

  Widget children(bool loadNext) {
    return CustomListView(
        scrollController: _scrollController,
        items: _viewModel.collectionApiResponse.data!,
        loadNext: loadNext,
        itemBuilder: (BuildContext context, Child item) {
          return ChildRow(onChildClicked: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ChildProfileScreen(child: item, isSubscriptionValid: true, onChildRemoved: () {  _viewModel.removeItemFromCollection(item); },)));
          },
              child: item);
        },
        direction: Axis.vertical);
  }
}
