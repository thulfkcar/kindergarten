import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../domain/Child.dart';

class ChildAddingScreen extends StatefulWidget {
  ChildAddingScreen({Key? key}) : super(key: key);
  AssetEntity? imagePath;

  @override
  State<ChildAddingScreen> createState() => _ChildAddingScreenState();
}

class _ChildAddingScreenState extends State<ChildAddingScreen> {
  TextEditingController childNameController = TextEditingController();
  List gender = [Gender.Male, Gender.Female];

  Gender select = Gender.Male;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Child"),
        ),
        body: SafeArea(
            maintainBottomViewPadding: true,
            child: Container(
                padding: EdgeInsets.fromLTRB(16, 22, 16, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              var entity = (await AssetPicker.pickAssets(
                                  context,
                                  pickerConfig: AssetPickerConfig()));
                              if (entity != null) {
                                setState(() {
                                  widget.imagePath = entity[0];
                                });
                              }
                            },
                            child: widget.imagePath != null
                                ? Container(
                                    height: 150.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1,
                                      ),
                                      image: DecorationImage(
                                        image: AssetEntityImageProvider(
                                            widget.imagePath!,
                                            isOriginal: false),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : Container(
                                    height: 150.0,
                                    width: 150.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                          ),
                          Container(
                              padding: const EdgeInsets.all(8),
                              child: const Text(
                                "Tap to add or change Image",
                              ))
                        ],
                      ),
                    ),
                    TextField(
                      controller: childNameController,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                width: 2,
                                color: Color(0xFF898989),
                                style: BorderStyle.none,
                              )),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          hintText: "ahmed hussein",
                          label: const Text("Child Name")),
                      maxLines: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        addRadioButton(0, 'Male'),
                        addRadioButton(1, 'Female'),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFF898989), width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.date_range),
                              Expanded(
                                  child: Row(children: [
                                const Text(
                                  "Birth Date:      ",
                                  style: TextStyle(color: Color(0xFF898989)),
                                ),
                                Text("${selectedDate.toLocal()}".split(' ')[0])
                              ])),
                            ],
                          )),
                    ),
                    Expanded(
                        child: TextButton(
                      child: Text("save"),
                      onPressed: () {},
                    ))
                  ],
                ))));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<Gender>(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (gender) {
            setState(() {
              print(gender.toString());
              select = gender!;
            });
          },
        ),
        Text(title)
      ],
    );
  }
}
