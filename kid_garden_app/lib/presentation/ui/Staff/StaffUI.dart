import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/presentation/ui/Staff/addStaff.dart';



class StaffUI extends ConsumerStatefulWidget {
  const StaffUI({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _StaffUIState();
}

class _StaffUIState extends ConsumerState<StaffUI> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "My Staff",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        actions: [
          Padding(padding: EdgeInsetsDirectional.all(16),child:
          GestureDetector(
            onTap: () {

              Navigator.push(context, MaterialPageRoute(builder: (context)=>StaffAdding()));
            },
            child: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),),
        ],
      ),
    );
  }
}
