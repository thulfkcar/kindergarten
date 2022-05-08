import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import 'package:kid_garden_app/presentation/ui/general_components/InfoCard.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../di/Modules.dart';
import '../general_components/CustomListView.dart';
import '../general_components/Error.dart';
import '../general_components/loading.dart';
import '../general_components/units/cards.dart';
import 'HomeViewModel.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeXXState createState() => _HomeXXState();
}

class _HomeXXState extends ConsumerState<Home> {
  late ScrollController _scrollController;
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()..addListener(getNext);
  }

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(HomeViewModelProvider(context));
    return Scaffold(
      body: Column(
        children: [
          Head(),
          body(),
        ],
      ),
    );
  }

  Widget Head() {
    var status = viewModel.homeInfoApiResponse.status;

    switch (status) {
      case Status.LOADING:
        return LoadingWidget();
      case Status.COMPLETED:
        return GridView.count(
          childAspectRatio: 2.8,
          shrinkWrap: true,
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.

          children: List.generate(viewModel.homeInfoApiResponse.data!.length,
              (index) {
            return InfoCard(
                homeData: viewModel.homeInfoApiResponse.data![index],
                startColor: index == 0
                    ? Color(0xFF00962A)
                    : index == 1
                        ? Color(0xFF00468A)
                        : index == 2
                            ? Color(0xFF00568A)
                            : Color(0xFF064544),
                endColor: Color(0xFFF2A384));
          }, growable: false),
        );
      case Status.ERROR:
        return MyErrorWidget(
          msg: viewModel.childActionResponse.message!,
          onRefresh: () {
            viewModel.fetchChildActions();
          },
        );
      default:
    }

    return Container();
  }

  Widget body() {
    var status = viewModel.childActionResponse.status;
    switch (status) {
      case Status.LOADING:
        return LoadingWidget();
      case Status.COMPLETED:
        return Expanded(
          child: CustomListView(
            scrollController: _scrollController,
            items: viewModel.childActionResponse.data!,
            loadNext: false,
            itemBuilder: (BuildContext context, ChildAction item) {
              return action4ImgCard(ScrollController(), item);
            },
            direction: Axis.vertical,
          ),
        );
      case Status.ERROR:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Head(),
            MyErrorWidget(
              msg: viewModel.childActionResponse.message!,
              onRefresh: () {
                viewModel.fetchChildActions();
              },
            )
          ],
        );
      case Status.LOADING_NEXT_PAGE:
        return CustomListView(
          scrollController: _scrollController,
          items: viewModel.childActionResponse.data!,
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

  void getNext() async {
    var state = viewModel.childActionResponse.status;
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      if (state == Status.COMPLETED && state != Status.LOADING_NEXT_PAGE) {
        await viewModel.fetchNextChildActions();
      }
    }
  }
}
