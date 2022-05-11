import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kid_garden_app/presentation/ui/general_components/units/buttons.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';
import 'package:kid_garden_app/them/DentalThem.dart';

class AboutCompany extends StatelessWidget {
  const AboutCompany({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)?.getText("phoenix") ??
            "Phoenix technology"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "res/images/phoenix.jpg",
                    height: 150,
                    width: 150,
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "jiojioji oojiohoiuh ohoihiohiohoihoih hoihiohoihoishuguhsdhjsd jbjun iuh oihhoicxoihahushushu ohduhoisoh sh"
                " ouhoishouhoidsohiohohio shoishihoihiohsdioh shoihsoih o hiohdih ihdoih ihiodh oish ioshoihshoihiohshhsoih"
                " ohioh hihhhiohdiohiooidh ioshdoihiosdhiohiohsd ihiosihiohiohi hsoihiodh",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customButton(
                  text: "send email",
                  icon: Icons.email,
                  mainColor: KidThem.female1,
                  backgroundColor: KidThem.female3,
                  onPressed: () {})
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customButton(
                  text: "dail",
                  icon: Icons.phone,
                  mainColor: KidThem.male1,
                  backgroundColor: KidThem.male3,
                  onPressed: () {})
            ],
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
