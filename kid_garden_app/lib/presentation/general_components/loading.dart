
import 'package:flutter/material.dart';
import 'package:kid_garden_app/presentation/utile/language_constrants.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            // const CircularProgressIndicator(),
            Image.asset("res/images/loading.gif",width: 60,height: 60,),
            const SizedBox(

              height: 8,
            ),
            Text(
              getTranslated("loading", context),
            )
          ],
        ));
  }
}