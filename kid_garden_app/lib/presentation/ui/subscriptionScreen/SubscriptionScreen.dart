import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/presentation/ui/general_components/ActionDialog.dart';

import '../../main.dart';
import '../../styles/colors_style.dart';
import '../general_components/units/texts.dart';
import '../login/SignUpScreen.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.male1,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: (MediaQuery.of(context).size.height * 0.5),
            decoration: BoxDecoration(
                color: ColorStyle.male1,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
          ),
          Column(
            children: [
              Image.asset(
                "res/images/logo_kindergarten.png",
                height: (MediaQuery.of(context).size.width * 0.4),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: (MediaQuery.of(context).size.height * 0.1),
                    bottom: (MediaQuery.of(context).size.height * 0.3)),
                decoration: BoxDecoration(
                    color: ColorStyle.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      titleText("Subscription issue", ColorStyle.text1),
                      descriptionText(
                        "your subscription has been ended, please enter new subscription by reading qr code of the subscription card",
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
                                        title: "Scan Subscription",
                                        message: "Point the Camera on QR Code",
                                        onCompleted: (qr) async {
                                          Navigator.pop(context);
                                          subscribe(qr!);
                                        },
                                      ));
                                });
                              },
                              child: titleText(
                                  "Scan Subscription QR", ColorStyle.male1),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorStyle.white),
                                  side: MaterialStateProperty.all(BorderSide(
                                      width: 1, color: ColorStyle.male1)),
                                  elevation: MaterialStateProperty.all(0)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
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
                title: "Subscribe",
                message: "Subscribing"));
        break;
      case Status.COMPLETED:
        showAlertDialog(
            context: context,
            messageDialog: ActionDialog(
              type: DialogType.completed,
              title: "Subscribe",
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
              title: "Subscribe",
              message: viewModel.userSubScribeApiResponse.message!,
              onCompleted: (s) {},
            ));
        break;
      default:
    }
  }
}
