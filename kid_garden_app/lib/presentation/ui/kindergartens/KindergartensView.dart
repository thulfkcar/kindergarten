import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/di/Modules.dart';
import 'package:kid_garden_app/domain/Kindergraten.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/general_components/Error.dart';
import 'package:kid_garden_app/presentation/ui/general_components/units/cards.dart';
import 'package:kid_garden_app/presentation/ui/general_components/units/floating_action_button.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/kindergartenViewModel.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/requestDialog.dart';

import '../../../data/network/ApiResponse.dart';
import '../general_components/CustomListView.dart';
import '../general_components/KindergratenCard.dart';
import '../general_components/loading.dart';

class KindergartensView extends ConsumerStatefulWidget {
  const KindergartensView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _KindergartensViewState();
}

class _KindergartensViewState extends ConsumerState<KindergartensView> {
  late KindergartenViewModel _viewModel;
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

    return body();
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
              return KindergartenCard(kindergraten: item);
            },
            direction: Axis.vertical);
        Column(
          children: [
            Container(
              height: 40,
              color: ColorStyle.female2,
              width: 40,
            ),
            radioChildCard(),
            kindergartensCard(),
            floatingActionButtonAdd22(onClicked: () {}),
            ElevatedButton(
              onPressed: () async {
                await showRequestDialog(
                    context: context, requestDialog: RequestDialog());
              },
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0.0),
                  backgroundColor: MaterialStateProperty.all(ColorStyle.male1),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // side: BorderSide()
                  ))),
              child: Text(
                "Join request",
                style: TextStyle(color: ColorStyle.white),
              ),
            ),
            Container(
              height: 300,
            ),
          ],
        );
      case Status.ERROR:
        return MyErrorWidget(
            msg: _viewModel.kindergartenApiResponse.message ?? "Error");

      case Status.LOADING_NEXT_PAGE:
        return CustomListView(
            scrollController: _scrollController,
            items: _viewModel.kindergartenApiResponse.data!,
            loadNext: true,
            itemBuilder: (BuildContext context, Kindergraten item) {
              return KindergartenCard(kindergraten: item);
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
}