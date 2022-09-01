import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/presentation/general_components/units/texts.dart';

import '../../domain/AssignRequest.dart';
import '../styles/colors_style.dart';
import '../utile/language_constrants.dart';
import 'KindergartenButton.dart';

class RequestedToKindergartenCard extends StatelessWidget {
  Function(String) onKindergartenClicked;
  AssignRequest assignRequest;
  Function() onCancelRequestClicked;

  RequestedToKindergartenCard(this.assignRequest, this.onKindergartenClicked,
      {Key? key, required this.onCancelRequestClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var status = assignRequest.requestStatus;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: status == RequestStatus.Pending
                  ? Container(
                      color: ColorStyle.main,
                      child: Center(
                        child: titleText(
                            getTranslated("request_Pending", context),
                            ColorStyle.text1),
                      ))
                  : status == RequestStatus.Rejected
                      ? Container(
                          color: ColorStyle.female1,
                          child: Center(
                              child: titleText(
                                  getTranslated("request_reject_des", context),
                                  ColorStyle.text1)),
                        )
                      : Container(),
            )
          ],
        ),
        assignRequest.kindergartenId != null
            ? Row(
                children: [
                  Expanded(
                    child: KindergartenButton(
                        name: assignRequest.kindergartenName!,
                        image: assignRequest.kindergartenImage!,
                        id: assignRequest.kindergartenId),
                  ),
                  MaterialButton(
                      onPressed: () {
                        onCancelRequestClicked();
                      },
                      child: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.redAccent,size: 40,
                      ),
                      color: Colors.transparent,
                      elevation: 0)
                ],
              )
            : Container()
      ],
    );
  }
}
