import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import 'package:kid_garden_app/domain/Media.dart';

import '../../domain/Child.dart';
import '../../them/DentalThem.dart';

class ChildrenExplorer extends StatefulWidget {
  ChildrenExplorer({Key? key}) : super(key: key);

  @override
  _childsExplorerState createState() => _childsExplorerState();
}

class _childsExplorerState extends State<ChildrenExplorer> {
  @override
  Widget build(BuildContext context) {
    final List<Child> children = [
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
      Child(
          name: "Dfsdf",
          id: "Fdgfdg",
          image: "https://picsum.photos/300/300?child"),
    ];

    return Scaffold(
      body: ListView.builder(
          itemCount: children.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 0.5),
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(30)),
              width: double.infinity,
              height: 100,
              child:InkWell (onTap: (){Navigator.pushNamed(context, "/ChildActivity");},child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(30), // Image radius
                              // child: Image.network('https://192.168.1.108:5126/StaticFiles/images/img.png',
                              child: Image.network(children[index].image,
                                  fit: BoxFit.cover),
                            ),
                          ),
                    // Image.network(children[index].image),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Title Here',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF090F13),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                              child: Text(
                                'Subtitle',
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF57636C),
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
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

            // Container(
            //   margin: EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //       border: Border.all(color: Colors.black12, width: 0.5),
            //       color: Colors.white70,
            //       borderRadius: BorderRadius.circular(30)),
            //   child:TextButton(onPressed: (){},child:  Padding(
            //     padding: EdgeInsets.all(10),
            //     child: Row(
            //       children: [
            //         Container(
            //           margin: EdgeInsets.all(10),
            //           padding: const EdgeInsets.all(12), // Border width
            //           decoration: const BoxDecoration(
            //               color: KidThem.imageBakGround, shape: BoxShape.circle),
            //           child: ClipOval(
            //             child: SizedBox.fromSize(
            //               size: const Size.fromRadius(16), // Image radius
            //               // child: Image.network('https://192.168.1.108:5126/StaticFiles/images/img.png',
            //               child: Image.network('https://picsum.photos/250?image=9',
            //                   fit: BoxFit.cover),
            //             ),
            //           ),
            //         ),
            //
            //         Expanded(child: Text(widget.children[index].name)),
            //         Icon(Icons.arrow_right_alt)
            //       ],
            //     ),
            //   )));
          }),
    );
  }
}
