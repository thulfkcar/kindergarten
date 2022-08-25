import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/network/BaseApiService.dart';
import '../../../domain/UserModel.dart';

class StaffCard extends StatelessWidget {
  UserModel user;
  double roundBy = 30;
  bool boarder;
  Function onClicked;

  StaffCard(
      {Key? key,
      required this.user,
      required this.roundBy,
      required this.boarder,
      required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
        decoration: BoxDecoration(
            border:
                boarder ? Border.all(color: Colors.black12, width: 0.5) : null,
            color: Colors.white70,
            borderRadius: BorderRadius.circular(roundBy)),
        width: double.infinity,
        height: 100,
        child: InkWell(
          onTap: () {
            onClicked();
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(30),
                    // Image radius
                    // user: Image.network('https://192.168.1.108:5126/StaticFiles/images/img.png',
                    child: user.image != null
                        ? Image.network(domain + user.image!, fit: BoxFit.cover)
                        : null,
                  ),
                ),
                // Image.network(userren[index].image),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name!,
                          style: const TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF090F13),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 4, 0, 0),
                            child: Row(
                              children: [
                                const Text(
                                  "children in care: ",
                                  style: TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF57636C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  user.childrenCount.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF57636C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 4, 0, 0),
                            child: Row(
                              children: [
                                const Text(
                                  "actions done: ",
                                  style: TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF57636C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  user.actionsCount.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF57636C),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 4),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF57636C),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
