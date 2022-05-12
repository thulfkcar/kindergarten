import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../data/network/BaseApiService.dart';
import '../general_components/units/cards.dart';

class AboutCompany extends StatefulWidget {
  const AboutCompany({Key? key}) : super(key: key);

  @override
  State<AboutCompany> createState() => _AboutCompanyState();
}

class _AboutCompanyState extends State<AboutCompany> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("About"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "res/images/phoenix.png",
                    height: 150,
                    width: 150,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(AppLocalizations.of(context)?.getText("phoenix") ??
                  "Phoenix technology"),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)?.getText("phoenix_des") ??
                    "شركة العنقاء لتكنولوجيا المعلومات تختص الشركة بتطوير تطبيقات سطح المكتب،الويب والهواتف الذكية والتطبيقات الخدمية والإدارية وخدمات التصميم.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  roundedClickableWithIcon(
                      icon: const Icon(
                        FontAwesomeIcons.facebook,
                        size: 30,
                        color: Colors.blueAccent,

                      ),
                      size: 40,
                      onClicked: () async {
                        final toFaceBook = Uri(
                            scheme: 'https',
                            path: "www.facebook.com/phoenix.company.iq");
                        await launchUrl(toFaceBook);
                      }),
                  roundedClickableWithIcon(
                      icon: const Icon(
                        FontAwesomeIcons.instagram,
                        size: 30,
                        color: Colors.redAccent,
                      ),
                      size: 40,
                      onClicked: () async {
                        final toInstagram=Uri(
                          scheme: 'http',
                          path: 'instagram.com/phoenix_company_iq'
                        );
                        await launchUrl(toInstagram);
                      }),
                  roundedClickableWithIcon(
                      icon: const Icon(
                        FontAwesomeIcons.phone,
                        size: 30,
                        color: Colors.green,
                      ),
                      size: 40,
                      onClicked: () async {
                        var toPhone=Uri(scheme: 'tel',path:"07802253870");
                        await launchUrl(toPhone);
                      }),
                  roundedClickableWithIcon(
                      icon: const Icon(
                        FontAwesomeIcons.mailBulk,
                        size: 30,
                        color: Colors.lightBlueAccent,
                      ),
                      size: 40,
                      onClicked: () async {
                        var mailto=Uri(scheme: 'mailto',path: 'phoenix.tech.2023@gmail.com',
                            queryParameters: {'subject': 'Example'});
                        await launchUrl(mailto);

                      }),
                  roundedClickableWithIcon(
                      icon: const Icon(
                        FontAwesomeIcons.telegram,
                        size: 30,
                        color: Colors.blueAccent,
                      ),
                      size: 40,
                      onClicked: () async {
                      //  telegram.me/<YourBotUsername>
                        final toTelegram = Uri(
                            scheme: 'https',
                            path: "t.me/phoenix_company_iq");
                        await launchUrl(toTelegram);
                      }),
                ],
              ),
              Text(
                AppLocalizations.of(context)?.getText("kindergarten_des") ??
                    "تطبيق الحضانات  هو خدمة توفر لك مراقبة الاحداث او الانشطة التي يقوم بها طفلك داخل الحضانة",
                textAlign: TextAlign.center,
              ),
              WebViewImpl(),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getPrivacyHtml(String path) async {
    var data = "";
    // await rootBundle.loadString(path).then((value) async {
    //
    //     data = value;
    //
    //
    // });

    return data;
  }
}

class WebViewImpl extends StatefulWidget {
  @override
  WebViewImplState createState() => WebViewImplState();
}

class WebViewImplState extends State<WebViewImpl> {
var myLocale="en";
  @override
  void didChangeDependencies() {
    Locale myLocale = Localizations.localeOf(context);
    this.myLocale=myLocale.toString();
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    //domain+"Resources/privacy_policy.html"
    return Container(
      height: 2800,
      child: WebView(
        initialUrl: domain +( myLocale=="ar"?'Resources/privacy_policy_ar.html':'Resources/privacy_policy.html'),
        // javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        gestureNavigationEnabled: true,
        backgroundColor: const Color(0x00000000),
      ),
    );
  }
}
