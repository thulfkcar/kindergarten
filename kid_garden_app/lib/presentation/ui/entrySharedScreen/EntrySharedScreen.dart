import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../styles/colors_style.dart';

class EntrySharedScreen extends ConsumerStatefulWidget {
  static String tag = 'sharedScreen';
Widget body;

  EntrySharedScreen({Key? key, required this.body}) : super(key: key);

  @override
  ConsumerState createState() => _EntrySharedScreenState();
}

class _EntrySharedScreenState extends ConsumerState<EntrySharedScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: ColorStyle.male1,
        elevation: 0,
      ),
      backgroundColor: ColorStyle.text6,
      body: Stack(children: [
        Container(
          height: (MediaQuery.of(context).size.height * 0.5),
          decoration: BoxDecoration(
              color: ColorStyle.male1,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "res/images/logo_kindergarten.png",
                height: (MediaQuery.of(context).size.width * 0.4),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 40,
                    right: 40,bottom: 8),
                decoration: BoxDecoration(
                    color: ColorStyle.white,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: widget.body
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }





}