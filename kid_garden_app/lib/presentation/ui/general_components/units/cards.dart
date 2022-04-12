import 'package:flutter/material.dart';
import 'package:kid_garden_app/data/network/BaseApiService.dart';
import 'package:kid_garden_app/domain/ChildAction.dart';
import 'package:kid_garden_app/presentation/ui/general_components/units/texts.dart';

import '../../../../domain/UserModel.dart';
import '../../../styles/colors_style.dart';
import 'images.dart';

Widget numberCard(String text, Color mainColor, Color backgroundColor) {
  return Card(
    color: backgroundColor,
    elevation: 0,
    margin: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: mainColor,
        ),
      ),
    ),
  );
}

Widget actionChildCard(ChildAction childAction) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: MaterialButton(
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      padding: EdgeInsets.zero,
      color: ColorStyle.text4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText(childAction.actionGroupName!, ColorStyle.text1),
                    descriptionText(
                        childAction.date!.toString(), ColorStyle.text2),
                    descriptionText(childAction.value, ColorStyle.text2),
                    descriptionText(childAction.userName!, ColorStyle.text2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget staffCard(UserModel user, Function(UserModel) onClicked) {
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
    child: MaterialButton(
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      padding: EdgeInsets.zero,
      color: ColorStyle.text4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {
        onClicked(user);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            imageCircleWithoutShadow(
                user.image != null
                    ? "domain${user.image}"
                    : "https://freepikpsd.com/file/2019/10/default-user-image-png-4-Transparent-Images.png",
                50),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText(user.name!, ColorStyle.text1),
                  descriptionText(
                      "children in care :${user.childrenCount ?? 0}",
                      ColorStyle.text2),
                  descriptionText(
                      "actions :${user.actionsCount ?? 0}", ColorStyle.text2),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget kindergartensCard() {
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
    child: MaterialButton(
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      padding: EdgeInsets.zero,
      color: ColorStyle.text4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            imageCircleWithoutShadow(
                "https://freepikpsd.com/file/2019/10/default-user-image-png-4-Transparent-Images.png",
                50),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText("kindergartens name ", ColorStyle.text1),
                  descriptionText("Children count : 300", ColorStyle.text2),
                  descriptionText(
                      "Actions count : 999,999,999,999", ColorStyle.text2),
                  descriptionText("Address : Najaf dn dn dn", ColorStyle.text2),
                  descriptionText(
                      "Phone Number : 07803497103", ColorStyle.text2),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget childActionNumberCard(String titleText1, String descriptionText1,
    BuildContext context, String url) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: MaterialButton(
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      padding: EdgeInsets.zero,
      color: ColorStyle.text4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            imageCircleWithoutShadow(url, 50),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText(titleText1, ColorStyle.text1),
                  descriptionText(descriptionText1, ColorStyle.text2),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget action4ImgCard(var scrollController, ChildAction childAction) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: MaterialButton(
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      padding: EdgeInsets.zero,
      color: ColorStyle.text4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  childAction.childName != null
                      ? titleText(childAction.childName!, ColorStyle.text1)
                      : Container(),
                  childAction.actionGroupName != null
                      ? titleText(
                          childAction.actionGroupName!, ColorStyle.text1)
                      : Container(),
                  descriptionText(childAction.value, ColorStyle.text2),
                  childAction.userName != null
                      ? descriptionText(
                          "Done by: ${childAction.userName}", ColorStyle.text2)
                      : Container(),
                  childAction.audience != null
                      ? descriptionText(
                          "Audience: ${childAction.audience.name}",
                          ColorStyle.text2)
                      : Container(),
                  const SizedBox(
                    height: 4,
                  ),
                  SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: childAction.medias != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              for (int i = 0;
                                  i < childAction.medias!.length;
                                  i++)
                                imageRectangleWithoutShadow(
                                    childAction.medias![i].url != null
                                        ? "$domain${childAction.medias![i].url}"
                                        : "https://freepikpsd.com/file/2019/10/default-user-image-png-4-Transparent-Images.png",
                                    50)
                            ],
                          )
                        : Container(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget roundedClickableWithIcon(
    {required Icon icon, required double size, required Function() onClicked}) {
  return Container(
    padding: EdgeInsets.zero,
    margin: const EdgeInsets.all(6),
    width: size,
    height: size,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      // border: Border.all(width: 1, color: ColorStyle.male1),
      shape: BoxShape.rectangle,
    ),
    child: MaterialButton(
      child: Padding(child:Center(child: icon),padding: const EdgeInsets.all(2),),
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      onPressed: () {
        onClicked();
      },
      padding: EdgeInsets.zero,
    ),
  );
}

Widget radioChildCard() {
  bool value22 = true;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: MaterialButton(
      elevation: 0,
      disabledElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      padding: EdgeInsets.zero,
      color: ColorStyle.text4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Checkbox(
              // fillColor: ColorStyle.male1,
              activeColor: ColorStyle.male1,
              value: value22,
              onChanged: (value) {
                value22 = false;
              }),
          const Expanded(child: Text("child name ")),
        ],
      ),
    ),
  );
}
