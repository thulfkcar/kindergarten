import 'package:flutter/material.dart';
import '../../../domain/Child.dart';

ChildRow ({required BuildContext context,required Child child, double roundBy=30,bool boarder=true}) {
  return Container(
      margin: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
      decoration: BoxDecoration(

          border:boarder? Border.all(color: Colors.black12, width: 0.5): null,
          color: Colors.white70,
          borderRadius: BorderRadius.circular(roundBy)),
      width: double.infinity,
      height: 100,
      child:InkWell (onTap: (){Navigator.pushNamed(context, "/ChildActions");},child: Padding(
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
                child: Image.network(child.image,
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


}