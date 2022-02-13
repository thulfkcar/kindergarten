import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaffUI extends StatefulWidget {
  const StaffUI({Key? key}) : super(key: key);

  @override
  _StaffUIState createState() => _StaffUIState();
}

class _StaffUIState extends State<StaffUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StaffListView(),
          Positioned(
            right: 10,
            bottom: 10,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {});
              },
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}

Widget StaffRow() {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(8),
          topRight: Radius.circular(0),
        ),
        child: Image.network(
          'https://picsum.photos/seed/544/600',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title',
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                  child: Text(
                    'Subtitle',
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(4, 4, 0, 0),
                  child: Text('subtext'),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget StaffListView() {
  return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 9,
      itemBuilder: (BuildContext context, int index) {
        return StaffRow();
      });
}
