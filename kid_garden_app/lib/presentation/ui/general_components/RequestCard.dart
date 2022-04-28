import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/domain/AssignRequest.dart';

import '../../../data/network/BaseApiService.dart';
import '../../../domain/Child.dart';
import '../../styles/colors_style.dart';

class RequestCard extends StatefulWidget {
  Function() onConfirmClicked;
  Function() onRejectClicked;

  RequestCard(
      {required this.onConfirmClicked,
      required this.onRejectClicked,
      required this.assignRequest,
      Key? key})
      : super(key: key);
  AssignRequest assignRequest;

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  @override
  Widget build(BuildContext context) {
    var status = widget.assignRequest.requestStatus;
    var request = widget.assignRequest;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorStyle.text4,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration( color: status == RequestStatus.Pending
                        ? ColorStyle.second
                        : status == RequestStatus.Joined
                        ? ColorStyle.male1
                        : status == RequestStatus.Rejected
                        ? ColorStyle.female1:ColorStyle.error,borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)) ),

                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                    child: Center(
                        child: Text(status == RequestStatus.Pending
                            ? "Pending"
                            : status == RequestStatus.Joined
                                ? "Accepted"
                                : status == RequestStatus.Rejected
                            ? "Rejected":"")),
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.black,
              height: 1,
            ),
            childWithParentCard(request.childName!, request.childImage!,
                request.childAge!, request.parentName!, request.gender!),
            Container(
              color: Colors.black,
              height: 1,
            ),
            ( request.message != null && request.requestStatus==RequestStatus.Rejected)
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            child: Center(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(request.message!,maxLines: 4,),
                            )),
                          ))
                        ],
                      ),
                      Container(
                        color: Colors.black,
                        height: 1,
                      ),
                    ],
                  )
                : Container(),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0)),
                        onPressed: () {
                          widget.onConfirmClicked();
                        },
                        child: Text(
                          "Accept",
                          style: TextStyle(color: ColorStyle.male1),
                        ))),
                Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0)),
                        onPressed: () {
                          widget.onRejectClicked();
                        },
                        child: Text(
                          "Reject",
                          style: TextStyle(color: ColorStyle.female1),
                        )))
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget childWithParentCard(
    String name, String image, int age, String parentName, Gender gender) {
  return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
      decoration: BoxDecoration(
          color: ColorStyle.text4, borderRadius: BorderRadius.circular(10)),
      // width: double.infinity,
      // height: 100,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipOval(
              child: SizedBox.fromSize(
                  size: const Size.fromRadius(30),
                  child: Image.network('$domain${image}', fit: BoxFit.cover)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name + " " + parentName,
                      style: const TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF090F13),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        gender == Gender.Female
                            ? Icon(
                                Icons.female,
                                // if child is female gender
                                // Icons.male,
                                color: ColorStyle.female1,
                                // color: ColorStyle.male1,
                                size: 20,
                              )
                            : Icon(
                                Icons.male,
                                // if child is female gender
                                // Icons.male,
                                color: ColorStyle.male1,
                                // color: ColorStyle.male1,
                                size: 20,
                              ),
                        Text(
                          age.toString(),
                          style: const TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF57636C),
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
}
