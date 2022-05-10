import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/di/Modules.dart';
import 'package:kid_garden_app/presentation/ui/Child/Childs.dart';
import 'package:kid_garden_app/presentation/ui/entrySharedScreen/EntrySharedScreen.dart';
import 'package:kid_garden_app/presentation/ui/dialogs/ActionDialog.dart';
import 'package:kid_garden_app/presentation/ui/login/LoginPageViewModel.dart';
import 'package:kid_garden_app/presentation/ui/navigationScreen/parent/parentChild/ParentChildrenScreen.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import '../../styles/colors_style.dart';
import '../../utile/RestartApp.dart';
import '../general_components/units/texts.dart';
import 'SubscriptionViewModel.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  String message;

  SubscriptionScreen({Key? key, required this.message}) : super(key: key);

  @override
  ConsumerState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  late SubscriptionViewModel viewModel;

  late LoginPageViewModel loginViewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(subscriptionViewModelProvider(false));
    loginViewModel = ref.watch(LoginPageViewModelProvider);
    return EntrySharedScreen(
      body: Column(
        children: [
          titleText(AppLocalizations.of(context)?.getText("sub_issue")??"Subscription issue", ColorStyle.text1),
          descriptionText(
            widget.message,
            ColorStyle.error,
          ),
          Image.asset(
            "res/images/qr_scan.gif",
            height: 100,
            width: 100,
            scale: 1,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Future.delayed(Duration.zero, () async {
                      showAlertDialog(
                          context: context,
                          messageDialog: ActionDialog(
                            type: DialogType.scanner,
                            title:AppLocalizations.of(context)?.getText("scan_sub_qr")?? "Scan Subscription",
                            message: AppLocalizations.of(context)?.getText("scan_sub_des")?? "Point the Camera on QR Code",
                            onCompleted: (qr) async {
                              Navigator.pop(context);
                              subscribe(qr!);
                            },
                          ));
                    });
                  },
                  child:
                      descriptionText(AppLocalizations.of(context)?.getText("scan_sub_qr")??"Scan Subscription QR", ColorStyle.male1),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorStyle.white),
                      side: MaterialStateProperty.all(
                          BorderSide(width: 1, color: ColorStyle.male1)),
                      elevation: MaterialStateProperty.all(0)),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    centerTitle: true,
                                    title:  Text(
                                     AppLocalizations.of(context)?.getText("your_children")?? "your children",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ),
                                  body: ParentChildrenScreen(
                                    fromProfile: true,
                                    isSubscriptionValid: false,
                                    subscriptionMessage:AppLocalizations.of(context)?.getText("subscription_des")??
                                        "your subscription invalid, please check your subscription status",
                                  ),
                                )));
                  },
                  child: descriptionText(AppLocalizations.of(context)?.getText("your_children")??"your Children", ColorStyle.main),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorStyle.white),
                      side: MaterialStateProperty.all(
                          BorderSide(width: 1, color: ColorStyle.main)),
                      elevation: MaterialStateProperty.all(0)),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Future.delayed(Duration.zero, () async {
                      await loginViewModel.logOut();

                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MyApp(key: UniqueKey(),)),
                      //       (Route<dynamic> route) => false,
                      // );
                      RestartWidget.restartApp(context);
                    });
                  },
                  child: descriptionText(AppLocalizations.of(context)?.getText("sign_out")??"Sign Out", ColorStyle.female1),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorStyle.white),
                      side: MaterialStateProperty.all(
                          BorderSide(width: 1, color: ColorStyle.female1)),
                      elevation: MaterialStateProperty.all(0)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void subscribe(String qr) async {
    await viewModel.subscribe(subscription: qr);
    var status = viewModel.userSubScribeApiResponse.status;
    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
                type: DialogType.loading,
                title: AppLocalizations.of(context)?.getText("subscribe")?? "Subscribe",
                message:AppLocalizations.of(context)?.getText("subscribing")?? "Subscribing"));
        break;
      case Status.COMPLETED:
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.completed,
              title: AppLocalizations.of(context)?.getText("subscribe")?? "Subscribe",
              message: viewModel.userSubScribeApiResponse.message!,
              onCompleted: (s) {
                viewModel.setSubscribeApiResponse(ApiResponse.non());
              },
            ));
        break;
      case Status.ERROR:
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.error,
              title: AppLocalizations.of(context)?.getText("subscribe")?? "Subscribe",
              message: viewModel.userSubScribeApiResponse.message!,
              onCompleted: (s) {},
            ));
        break;
      default:
    }
  }
}
