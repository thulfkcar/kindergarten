import 'package:flutter/material.dart';
import 'package:kid_garden_app/data/network/BaseApiService.dart';
import '../../../domain/Child.dart';
import '../childActions/ChildActions.dart';

childRow ({required BuildContext context,required Child child, double roundBy=30,bool boarder=true}) {
  return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
      decoration: BoxDecoration(

          border:boarder? Border.all(color: Colors.black12, width: 0.5): null,
          color: Colors.white70,
          borderRadius: BorderRadius.circular(roundBy)),
      width: double.infinity,
      height: 100,
      child:InkWell (onTap: (){

        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChildActions(childId: child.id,)));
        // Navigator.pushNamed(context, "/ChildActions",arguments: {'id':child.id});

        },child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(30), // Image radius
                // child: Image.network('https://192.168.1.108:5126/StaticFiles/images/img.png',
                child:child.image!=null ? Image.network(domain +child.image!,fit: BoxFit.cover):null,
              ),
            ),
            // Image.network(children[index].image),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      child.name,
                      style: const TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF090F13),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                     Padding(
                      padding:
                      const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        child.age.toString(),
                        style: const TextStyle(
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