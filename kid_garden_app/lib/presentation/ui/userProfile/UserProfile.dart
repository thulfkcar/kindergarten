import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/di/Modules.dart';
import 'package:kid_garden_app/domain/Contact.dart';
import 'package:kid_garden_app/domain/Kindergraten.dart';
import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:kid_garden_app/presentation/ui/general_components/Error.dart';
import 'package:kid_garden_app/presentation/ui/general_components/InfoCard.dart';
import 'package:kid_garden_app/presentation/ui/general_components/KindergratenCard.dart';
import 'package:kid_garden_app/presentation/ui/general_components/loading.dart';
import 'package:kid_garden_app/presentation/ui/userProfile/UserProfileViewModel.dart';
import 'package:tuple/tuple.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../data/network/BaseApiService.dart';
import '../../styles/colors_style.dart';
import '../Child/Childs.dart';
import '../general_components/ContactList.dart';
import '../general_components/units/images.dart';
import '../general_components/units/texts.dart';

class UserProfile extends ConsumerStatefulWidget {
  String userId;
  Role userType;

  UserProfile({
    required this.userType,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  late UserProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(userProfileViewModelProvider(widget.userId));
    return  SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: body(),
          bottomSheet:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(ColorStyle.female3),
                        elevation: MaterialStateProperty.all(0)),
                    child:  Text('Delete' ,style: TextStyle(color: ColorStyle.female1),),
                    onPressed: () async {

                    },
                  ),
                  SizedBox(width: 20,),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(ColorStyle.male3),
                        elevation: MaterialStateProperty.all(0)),
                    child:  Text('Edit',style: TextStyle(color: ColorStyle.male1),),
                    onPressed: () async {

                    },
                  ),
                ],
            ),
          ]),
              )),
    );
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
              viewModel.getUser(userId: widget.userId);
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
                    Row(
                      children: [
                        descriptionText("Adress:", ColorStyle.text1),
                        descriptionText("Najaf, street 22.", ColorStyle.text2),
                        Expanded(child: Container())
                      ],
                    ),
                    ContactList(contact: Contact(name: user.name!,email: user.email, phone: user.phone!, role: user.role),)

                  ],
                )),
                imageRectangleWithoutShadow(
                    user.image != null
                        ? domain + user.image!
                        : "https://freepikpsd.com/file/2019/10/default-user-image-png-4-Transparent-Images.png",
                    90),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InfoCard(
                  homeData:
                      Tuple2("Actions Count",user.actionsCount !=null? (user.actionsCount.toString()):"0"),
                  startColor: Color(0xFFA1B327),
                  endColor: Color(0xFFF2A384),
                  width: 150,
                ),

                MaterialButton(
                  padding: EdgeInsets.all(0),
                  minWidth: 0,
                  onPressed: () {  },
                  child:  InfoCard(
                    homeData: Tuple2("Children",user.childrenCount!=null? user.childrenCount.toString():"0"),
                    startColor: Color(0xff89C7E7),
                    endColor: Color(0xFFF2A384),
                    width: 150,
                  ),
                )



              ],
            ),
          user.role==Role.Parents?  KindergartenCard(
                kindergraten: Kindergraten(
                    id: "id",
                    name: "name",
                    location: "location",
                    latitudes: 54545,
                    longitudes: 4545,
                    phone: "phone",
                    ditance: "5454",
                    media: null)): Container(),
            // ( user.role==Role.admin || user.role==Role.superAdmin)? const ChildrenExplorer():Container(),

             Expanded(
              child: ChildrenExplorer(fromProfile: false,subUserId: widget.userId,),
            ),
          ],
        ));
  }
}
