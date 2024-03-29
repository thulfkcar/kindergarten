import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/di/Modules.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/kindergartenViewModel.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginOrSignUpScreen.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import '../../../data/network/ApiResponse.dart';
import '../../../domain/Kindergarten.dart';
import '../../general_components/CustomListView.dart';
import '../../general_components/Error.dart';
import '../../general_components/KindergratenCard.dart';
import '../../general_components/loading.dart';
import '../../utile/LangUtiles.dart';
import '../dialogs/dialogs.dart';
import '../navigationX/parent/parentChildren/ParentChildrenViewModel.dart';

class KindergartenScreen extends ConsumerStatefulWidget {
  final String? childId;
  final Function(String)? onKindergartenChoosed;

  const KindergartenScreen({
     this.onKindergartenChoosed,
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
    loginViewModel = ref.watch(LoginPageViewModelProvider);
    if(widget.childId!=null) {
      viewModelParentChildrenShared = ref.watch(parentChildrenViewModelProvider);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)?.getText("app_name") ?? "Error"),
      ),
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
                    child:  Text(
                     AppLocalizations.of(context)?.getText("login")??"Login",
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginOrSignUpScreen()));
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
          Expanded(child: kindergartens())
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
        decoration:  InputDecoration(
            labelText: AppLocalizations.of(context)?.getText("search")?? "Search",
            hintText: AppLocalizations.of(context)?.getText("search")?? "Search",
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }


  Widget kindergartens() {
    var status = _viewModel.kindergartenApiResponse.status;

    switch (status) {
      case Status.LOADING:
        return LoadingWidget();

      case Status.COMPLETED:
        return CustomListView(
            scrollController: _scrollController,
            items: _viewModel.kindergartenApiResponse.data!,
            loadNext: false,
            itemBuilder: (BuildContext context, Kindergarten item) {
              return joinKindergartenCard(item,context);
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
            itemBuilder: (BuildContext context, Kindergarten item) {
              return joinKindergartenCard(item,context);
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

  Widget joinKindergartenCard(Kindergarten kindergraten,BuildContext context) {
    return KindergartenCard(
      kindergraten: kindergraten,
      addRequestEnable: widget.childId != null ? true : false,
      onAddRequestClicked: (id) {
        showDialogGeneric(
            context: context,
            dialog: ConfirmationDialog(
                title: getTranslated("joining_request", context),
                message:getTranslated("joining_request_des", context),
                confirmed: () {
                 widget.onKindergartenChoosed!(kindergraten.id);
                  Navigator.pop(context);


                }));
      },
    );
  }

}
