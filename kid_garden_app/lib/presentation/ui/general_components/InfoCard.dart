import 'package:flutter/cupertino.dart';

class InfoCard extends StatelessWidget {
  String title;
  String value;
  Color startColor;
  Color endColor;

   InfoCard({Key? key,required this.title,required this.value,required this.startColor,required this.endColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 6,
              color: Color(0x4B1A1F24),
              offset: Offset(0, 2),
            )
          ],
          gradient:  LinearGradient(
            colors: [startColor, endColor],
            stops: [0, 1],
            begin: AlignmentDirectional(0.94, -1),
            end: AlignmentDirectional(-0.94, 1),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 20, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF262D34),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: Color(0xFF262D34),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );


  }
}
