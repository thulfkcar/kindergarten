import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../data/network/BaseApiService.dart';
import '../../../../../di/Modules.dart';
import '../../../../../domain/Contact.dart';
import '../../../../../domain/UserModel.dart';
import '../../../../general_components/ContactList.dart';
import '../../../../general_components/units/images.dart';
import '../../../../general_components/units/texts.dart';
import '../../../../styles/colors_style.dart';
import '../../../../utile/LangUtiles.dart';
import '../../../kindergartens/kindergartenScreen.dart';
import '../../../login/LoginPageViewModel.dart';
import '../../../userProfile/UserProfileViewModel.dart';

class AdminProfileScreen extends ConsumerStatefulWidget {
  const AdminProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends ConsumerState<AdminProfileScreen> {
  late UserProfileViewModel viewModel;
  late LoginPageViewModel viewModelLogin;

  @override
  Widget build(BuildContext context) {
    viewModelLogin = ref.watch(LoginPageViewModelProvider);
    var user = ref.watch(hiveProvider).value!.getUser();
    if (user != null) {
      viewModel = ref.watch(userProfileViewModelProvider(user.id!));
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: user?.id != null
              ? const Text(
                  "Profile",
                  style: TextStyle(color: Colors.black),
                )
              : Container(),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0)),
                onPressed: () async {
                  Future.delayed(Duration.zero, () async {
                    await ref.watch(hiveProvider).value!.storeUser(null);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const KindergartenScreen()),
                        (route) => false);
                  });
                },
                child: const Icon(Icons.logout))
          ],
        ),
        body: profile(user!),
        bottomSheet: (user.id != null)
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 0,
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Future.delayed(Duration.zero, () async {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const KindergartenScreen()),
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
                          side: MaterialStateProperty.all(
                              BorderSide(width: 1, color: ColorStyle.female1)),
                          elevation: MaterialStateProperty.all(0)),
                    ),
                  ),
                ],
              ));
  }

  Widget profile(UserModel user) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Column(
                  children: [
                    ContactListCard(false,
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
          ],
        ));
  }
}
