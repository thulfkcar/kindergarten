import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/di/Modules.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/kindergartenViewModel.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginOrSignUpScreen.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import '../../../data/network/ApiResponse.dart';
import 'KindergartensView.dart';

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
