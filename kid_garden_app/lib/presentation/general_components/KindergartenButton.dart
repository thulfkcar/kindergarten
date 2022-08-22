import 'package:flutter/material.dart';
import '../../data/network/BaseApiService.dart';
import '../../them/DentalThem.dart';

class KindergartenButton extends StatelessWidget {
  String? id;
  String image;
  String name;
  KindergartenButton(
      {Key? key, this.id, required this.image, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        //toDo:onclick kindergartenProfile...
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.network(
                  domain + image,
                  width: 70,
                  height: 70,
                )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                name,
              ),
            ),
          ],
        ),
      ),
      style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(KidThem.white),
          side: MaterialStateProperty.all(
              BorderSide(width: 1, color: KidThem.male1)),
          elevation: MaterialStateProperty.all(0)),
    );
  }
}
