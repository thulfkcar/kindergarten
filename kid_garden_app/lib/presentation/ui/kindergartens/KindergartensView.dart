import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/di/Modules.dart';
import 'package:kid_garden_app/domain/Kindergraten.dart';
import 'package:kid_garden_app/presentation/ui/general_components/Error.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/kindergartenViewModel.dart';
import '../../../data/network/ApiResponse.dart';
import '../dialogs/dialogs.dart';
import '../general_components/CustomListView.dart';
import '../general_components/KindergratenCard.dart';
import '../general_components/loading.dart';
import '../navigationScreen/parent/parentChild/ParentChildrenViewModel.dart';

class KindergartensView extends ConsumerStatefulWidget {
  String? childId;
  KindergartensView({
    required this.childId,
    Key? key,
  }) : super(key: key);
  @override
  ConsumerState createState() => _KindergartensViewState();
}
class _KindergartensViewState extends ConsumerState<KindergartensView> {
  late KindergartenViewModel _viewModel;
  late ScrollController _scrollController;
  late ParentChildrenViewModel viewModelParentChildrenShared;
  TextEditingController editingController = TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController = ScrollController()..addListener(getNext);
  }
  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(kindergartenViewModelProvider);
    if(widget.childId!=null)
    viewModelParentChildrenShared = ref.watch(parentChildrenViewModelProvider);

    return body();
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
              return kinderCard(item,context);
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
              return kinderCard(item,context);
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
  Widget kinderCard(Kindergraten item,BuildContext context) {
    return KindergartenCard(
      kindergraten: item,
      addRequestEnable: widget.childId != null ? true : false,
      onAddRequestClicked: (id) {
        showDialogGeneric(
            context: context,
            dialog: ConfirmationDialog(
                title: "Joining Request",
                message:
                    "do you want to make your child joining this Kindergarten?",
                confirmed: () {
                  viewModelParentChildrenShared.setRequestedKindergartenId(item.id);
                    Navigator.pop(context);


                }));
      },
    );
  }
}
