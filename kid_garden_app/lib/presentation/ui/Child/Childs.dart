import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildAddingScreen.dart';
import 'package:kid_garden_app/presentation/ui/Child/ChildViewModel.dart';
import 'package:kid_garden_app/presentation/ui/general_components/Error.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../di/Modules.dart';
import '../../../domain/Child.dart';
import '../general_components/ChildRow.dart';
import '../general_components/CustomListView.dart';
import '../general_components/loading.dart';
import '../general_components/units/floating_action_button.dart';

class ChildrenExplorer extends ConsumerStatefulWidget {
 bool fromProfile;
 String? subUserId;
   ChildrenExplorer({
   required this.fromProfile,
     this.subUserId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ChildrenExplorerState();
}

class _ChildrenExplorerState extends ConsumerState<ChildrenExplorer> {
  late ScrollController _scrollController;
  late ChildViewModel _viewModel;
  TextEditingController editingController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()..addListener(getNext);
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(childViewModelProvider(widget.subUserId));

    return Scaffold(
      body: Column(
        children: [widget.fromProfile?head():Container(), Expanded(child: body())],
      ),

         floatingActionButton:widget.fromProfile? floatingActionButtonAdd22(onClicked: () {   Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChildAddingScreen())); }):null,
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
            scrollController: _scrollController,
            items: _viewModel.childListResponse.data!,
            loadNext: false,
            itemBuilder: (BuildContext context, Child item) {
              return childRow(context: context, child: item);
            },
            direction: Axis.vertical);
      case Status.ERROR:
        return MyErrorWidget(
            msg: _viewModel.childListResponse.message ?? "Error");

      case Status.LOADING_NEXT_PAGE:
        return CustomListView(
            scrollController: _scrollController,
            items: _viewModel.childListResponse.data!,
            loadNext: true,
            itemBuilder: (BuildContext context, Child item) {
              return childRow(context: context, child: item);
            },
            direction: Axis.vertical);

      case Status.NON:
        return Container();
      default:
    }
    return Container();
  }

  void getNext() async {
    var state = _viewModel.childListResponse.status;
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      if (state == Status.COMPLETED && state != Status.LOADING_NEXT_PAGE) {
        await _viewModel.fetchNextChildren();
      }
    }
  }
}
