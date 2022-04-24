import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/domain/Kindergraten.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';

import '../../../data/network/BaseApiService.dart';

class KindergartenCard extends StatelessWidget {
  Kindergraten kindergraten;
  Function(String) onAddRequestClicked;
  bool addRequestEnable = false;

  KindergartenCard(
      {Key? key,
      required this.kindergraten,
      required this.addRequestEnable,
    required  this.onAddRequestClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: ColorStyle.text4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.network(
                  domain + kindergraten.media!.url,
                  width: 70,
                  height: 70,
                )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kindergraten.name,
                    style: TextStyle(
                        color: ColorStyle.text1,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "about ${kindergraten.ditance} meter",
                    style: TextStyle(color: ColorStyle.text2),
                  ),
                  Text(
                    kindergraten.location,
                    style: TextStyle(color: ColorStyle.text2),
                  ),
                  Text(
                    kindergraten.phone,
                    style: TextStyle(color: ColorStyle.text2),
                  ),
                ],
              ),
            ),
            addRequestEnable == true
                ? ElevatedButton(
                    onPressed: () {
                        onAddRequestClicked(kindergraten.id);

                    },
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0.0),
                        backgroundColor:
                            MaterialStateProperty.all(ColorStyle.male1),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // side: BorderSide()
                        ))),
                    child: Text(
                      "Join request",
                      style: TextStyle(color: ColorStyle.white),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
