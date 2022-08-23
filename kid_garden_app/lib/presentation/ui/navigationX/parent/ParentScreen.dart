import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/parent/parentChildren/ParentChildrenScreen.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/parent/subscriptionScreen/SubscriptionScreen.dart';
import 'package:kid_garden_app/presentation/ui/navigationX/parent/subscriptionScreen/SubscriptionViewModel.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';
import '../../../../data/network/ApiResponse.dart';
import '../../../../di/Modules.dart';
import '../../../../domain/UserModel.dart';
import '../../../../them/DentalThem.dart';
import '../../dialogs/ActionDialog.dart';
import '../../userProfile/UserProfile.dart';
class ParentScreen extends ConsumerStatefulWidget {
  ParentScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<ParentScreen> createState() =>
      _NavigationScreenParentState();
}

class _NavigationScreenParentState
    extends ConsumerState<ParentScreen> {
  late SubscriptionViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(subscriptionViewModelProvider(true));
    Future.delayed(Duration.zero, () async {
      checkParentSubscription();
    });
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0)),
              onPressed: () async {
                ProviderContainer().read(userProvider).whenOrNull(data:(user){
                  showAlertDialog(
                      context: context,
                      messageDialog: ActionDialog(
                          type: DialogType.qr,
                          qr: user!.id,
                          title: getTranslated("self_identity", context),
                          message: getTranslated("scan_for_Operation", context)));
                });


              },
              child: const Icon(Icons.qr_code)),
        ],
        leading: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0)),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile(self: true,
                        userType: Role.Parents,
                        userId: null,
                      )));
            },
            child: const Icon(Icons.person)),
        automaticallyImplyLeading: true,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: TextStyle(color: KidThem.textTitleColor),
        ),
      ),
      body: Center(
        child: ParentChildrenScreen(
          fromProfile: true, isSubscriptionValid: true,
        ),
      ),
    );
  }

  checkParentSubscription() async {
    var status = viewModel.userSubscriptionStatusResponse.status;

    switch (status) {
      case Status.LOADING:
        break;
      case Status.COMPLETED:
        await viewModel
            .setUserSubscriptionStatusResponse(ApiResponse.non())
            .then((value) async {
          // await Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) =>
          //           NavigationScreenParent(title: 'Parent App')),
          //   (Route<dynamic> route) => false,
          // );
        });
        break;
      case Status.ERROR:
        var errorMessage =
        viewModel.userSubscriptionStatusResponse.message != null
            ? viewModel.userSubscriptionStatusResponse.message!
            : "corrupted";
        await viewModel
            .setUserSubscriptionStatusResponse(ApiResponse.non())
            .then((value) async {
          Navigator.pop(context);

          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SubscriptionScreen(message: errorMessage)),
                (Route<dynamic> route) => true,
          );
        });

        break;

      default:
    }
  }
}
