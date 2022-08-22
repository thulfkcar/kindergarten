import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/di/Modules.dart';
import 'package:kid_garden_app/domain/Contact.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/general_components/ContactList.dart';
import 'package:kid_garden_app/presentation/general_components/units/images.dart';
import 'package:kid_garden_app/presentation/general_components/units/texts.dart';
import 'package:kid_garden_app/presentation/ui/AdminRequestsScreen/AdminRequestScreen.dart';
import 'package:kid_garden_app/presentation/general_components/Error.dart';
import 'package:kid_garden_app/presentation/general_components/InfoCard.dart';
import 'package:kid_garden_app/presentation/general_components/loading.dart';
import 'package:kid_garden_app/presentation/ui/kindergartens/kindergartenScreen.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/userProfile/UserProfileViewModel.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:tuple/tuple.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../data/network/BaseApiService.dart';
import '../../styles/colors_style.dart';
import '../../utile/RestartApp.dart';
import '../Child/Childs.dart';
import '../navigationX/parent/parentChildren/ParentChildrenScreen.dart';

class UserProfile extends ConsumerStatefulWidget {
  String? userId;
  Role userType;
  bool self;

  UserProfile({
    required this.self,
    required this.userType,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  late UserProfileViewModel viewModel;
  late LoginPageViewModel viewModelLogin;
  String? id;

  @override
  Widget build(BuildContext context) {
    viewModelLogin = ref.watch(LoginPageViewModelProvider);
    id = viewModelLogin.currentUser!.id;
    viewModel = ref.watch(userProfileViewModelProvider(
        widget.userId == null ? id! : widget.userId!));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: widget.userId != null
              ? const Text(
                  "Profile",
                  style: TextStyle(color: Colors.black),
                )
              : Container(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: body(),
        ),
        bottomSheet: (widget.userId != null)
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 0,
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: (widget.self &&
                              (widget.userType == Role.Parents ||
                                  widget.userType == Role.Staff))
                          ? const EdgeInsets.only(
                              left: 30, right: 30, bottom: 30)
                          : const EdgeInsets.only(left: 30, right: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          Future.delayed(Duration.zero, () async {
                            await viewModelLogin.logOut();

                            // RestartWidget.restartApp(context);

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => KindergartenScreen()),
                                (route) => false);
                          });
                        },
                        child: descriptionText(
                            AppLocalizations.of(context)?.getText("sign_out") ??
                                "Sign Out",
                            ColorStyle.female1),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(ColorStyle.white),
                            side: MaterialStateProperty.all(BorderSide(
                                width: 1, color: ColorStyle.female1)),
                            elevation: MaterialStateProperty.all(0)),
                      ),
                    ),
                  ),
                ],
              ));
  }

  Widget body() {
    var state = viewModel.staffProfileResult.status;
    switch (state) {
      case Status.LOADING:
        return LoadingWidget();
      case Status.COMPLETED:
        return profile(viewModel.staffProfileResult.data!);
      case Status.ERROR:
        return MyErrorWidget(
            msg: "error on fetching staff profile",
            onRefresh: () {
              viewModel.getUser(
                  userId: widget.userId == null ? id! : widget.userId!);
            });
      case Status.NON:
        return Container();
      default:
    }
    return Container();
  }

  Widget profile(UserModel user) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Column(
                  children: [
                    // Row(
                    //   children: [
                    //     descriptionText("Adress:", ColorStyle.text1),
                    //     descriptionText("Najaf, street 22.", ColorStyle.text2),
                    //     Expanded(child: Container())
                    //   ],
                    // ),
                    ContactList(widget.userId != null ? true : false,
                        contact: Contact(
                            name: user.name!,
                            email: user.email,
                            phone: user.phone!,
                            userType: user.role.name.toString()))
                  ],
                )),
                imageRectangleWithoutShadow(domain + user.image!, 90),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InfoCard(
                  homeData: Tuple2(
                      AppLocalizations.of(context)?.getText("total_actions") ??
                          "Actions Count",
                      user.actionsCount != null
                          ? (user.actionsCount.toString())
                          : "0"),
                  startColor: Color(0xFFA1B327),
                  endColor: Color(0xFFF2A384),
                  width: 150,
                ),
                MaterialButton(
                  padding: EdgeInsets.all(0),
                  minWidth: 0,
                  onPressed: () {},
                  child: InfoCard(
                    homeData: Tuple2(
                        AppLocalizations.of(context)?.getText("children") ??
                            "Children",
                        user.childrenCount != null
                            ? user.childrenCount.toString()
                            : "0"),
                    startColor: Color(0xff89C7E7),
                    endColor: Color(0xFFF2A384),
                    width: 150,
                  ),
                )
              ],
            ),

            // ( user.role==Role.admin || user.role==Role.superAdmin)? const ChildrenExplorer():Container(),

            Expanded(
              child: (user.role == Role.Staff)
                  ? ChildrenExplorer(
                      fromProfile: false,
                      subUserId: widget.userId,
                    )
                  : (user.role == Role.Parents && widget.self == false)
                      ? ChildrenExplorer(
                          fromProfile: false,
                          subUserId: widget.userId,
                        )
                      : (user.role == Role.Parents && widget.self == true)
                          ? ParentChildrenScreen(
                              isSubscriptionValid: true, fromProfile: false)
                          : const AdminRequestsScreen(),
            ),
          ],
        ));
  }
}
