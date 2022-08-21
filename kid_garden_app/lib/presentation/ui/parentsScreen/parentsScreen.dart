import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/general_components/CustomListView.dart';
import 'package:kid_garden_app/presentation/general_components/Error.dart';
import 'package:kid_garden_app/presentation/general_components/loading.dart';
import 'package:kid_garden_app/presentation/general_components/units/cards.dart';
import 'package:kid_garden_app/presentation/ui/parentsScreen/parentViewModel.dart';
import 'package:kid_garden_app/presentation/ui/userProfile/UserProfile.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../di/Modules.dart';
import '../../utile/LangUtiles.dart';

class ParentsScreen extends ConsumerStatefulWidget {
  const ParentsScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ParentsScreenState();
}

class _ParentsScreenState extends ConsumerState<ParentsScreen> {
  late ScrollController _scrollController;
  late ParentViewModel _viewModel;
  TextEditingController editingController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()..addListener(getNext);
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(parentViewModelProvider);

    return Scaffold(
      body: Column(
        children: [head(), Expanded(child: body())],
      ),
      // floatingActionButton: floatingActionButtonAdd22(onClicked: () {  }),
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
        decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context)?.getText("search") ?? "Search",
            hintText:
                AppLocalizations.of(context)?.getText("search") ?? "Search",
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }

  Widget body() {
    var status = _viewModel.parentListResponse.status;

    switch (status) {
      case Status.LOADING:
        return LoadingWidget();

      case Status.COMPLETED:
        return CustomListView(
            scrollController: _scrollController,
            items: _viewModel.parentListResponse.data!,
            loadNext: false,
            itemBuilder: (BuildContext context, UserModel item) {
              return staffCard(item, (user) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => UserProfile(
                            self: false,
                            userType: Role.Parents,
                            userId: user.id)));
              });
            },
            direction: Axis.vertical);
      case Status.ERROR:
        return MyErrorWidget(
            msg: _viewModel.parentListResponse.message ?? "Error");

      case Status.LOADING_NEXT_PAGE:
        return CustomListView(
            scrollController: _scrollController,
            items: _viewModel.parentListResponse.data!,
            loadNext: true,
            itemBuilder: (BuildContext context, UserModel item) {
              return staffCard(
                item,
                (user) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => UserProfile(
                              self: false,
                              userType: Role.Parents,
                              userId: user.id)));
                },
              );
            },
            direction: Axis.vertical);

      case Status.NON:
        return Container();
      default:
    }
    return Container();
  }

  void getNext() async {
    var state = _viewModel.parentListResponse.status;
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      if (state == Status.COMPLETED && state != Status.LOADING_NEXT_PAGE) {
        await _viewModel.fetchNextParents();
      }
    }
  }
}
