import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';

class InfoCard extends StatelessWidget {
  Tuple2<String, String> homeData;
  Color startColor;
  Color endColor;
  double? width;

  InfoCard(
      {Key? key,
      required this.homeData,
      required this.startColor,
      required this.endColor,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: width ?? MediaQuery.of(context).size.width * 0.92,
        // height: 20,
        decoration: BoxDecoration(
          // boxShadow: const [
          //   BoxShadow(
          //     blurRadius: 8,
          //     color: Color(0x4B1A1F24),
          //     offset: Offset(0, 2),
          //   )
          // ],
          gradient: LinearGradient(
            colors: [startColor, endColor],
            stops: [0, 1],
            begin: AlignmentDirectional(0.94, -1),
            end: AlignmentDirectional(-0.94, 1),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                homeData.item1,
                style: const TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF262D34),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              // SizedBox(height: 4,),
              Text(
                homeData.item2,
                style: const TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF262D34),
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
