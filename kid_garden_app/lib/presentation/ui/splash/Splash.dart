import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utile/LangUtiles.dart';

class SplashScreen extends StatefulWidget {
  Function() completed;

  SplashScreen({Key? key, required this.completed}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("res/images/logo_kindergarten.png"), fit: BoxFit.fitWidth),
        // ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("res/images/logo_kindergarten.png"),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              Text(
                StringResources.of(context)?.getText("app_name") ?? "Error",
                style: TextStyle(fontSize: 50.0),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              const SizedBox(
                height: 20,
              ),
              const CircularProgressIndicator(),
              const SizedBox(height: 20.0),
              const Text(
                'Initializing app...',
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
            ]),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, mainWidget);
  }

  mainWidget() {
    widget.completed();
  }

  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }
}
