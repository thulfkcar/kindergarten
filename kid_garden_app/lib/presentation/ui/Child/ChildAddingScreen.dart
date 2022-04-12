import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/data/network/FromData/ChildForm.dart';
import 'package:tuple/tuple.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../di/Modules.dart';
import '../../../domain/Child.dart';
import 'ChildViewModel.dart';
import '../general_components/ActionDialog.dart';

class ChildAddingScreen extends ConsumerStatefulWidget {
  ChildAddingScreen({
    Key? key,
  }) : super(key: key);
  AssetEntity? imagePath;

  @override
  ConsumerState createState() => _ChildAddingScreenState();
}

class _ChildAddingScreenState extends ConsumerState<ChildAddingScreen> {
 late ChildViewModel _viewModel;
  TextEditingController childNameController = TextEditingController();
  List gender = [Gender.Male, Gender.Female];
  ScrollController scrollController = ScrollController();
  Gender selectedGender = Gender.Male;
  DateTime selectedDate = DateTime.now().toUtc();
  String message = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(childViewModelProvider(null));
    Future.delayed(Duration.zero, () async {
      postingChildResponse();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Child"),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
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
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 100, 0, 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            Tuple2 result = validateAddChildInputs();
                            if (result.item1 != null) {
                              await _viewModel.addChild(
                                  childForm: result.item1);
                            } else {
                              setState(() {
                                showAlertDialog(context: context,
                                    messageDialog: ActionDialog(
                                  type: DialogType.error,
                                  title: 'Input Validation',
                                  message: result.item2,
                                  delay: 4000,
                                  onCompleted: () {},
                                ));
                              });
                            }
                          },
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0.0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide()))),
                          child: Text("Add"),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked.toUtc();
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
          groupValue: selectedGender,
          onChanged: (gender) {
            setState(() {
              print(gender.toString());
              selectedGender = gender!;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  Tuple2<ChildForm?, String> validateAddChildInputs() {
    if (childNameController.text.trim().isEmpty) {
      return const Tuple2(null, "pleas enter child name");
    }
    if (widget.imagePath == null) {
      return const Tuple2(null, "please choose poper image");
    }
    return Tuple2(
        ChildForm(
            childName: childNameController.text,
            birthDate: selectedDate.toUtc(),
            gender: selectedGender.index,
            imageFile: widget.imagePath!),
        "adding image scheduled");
  }

  void postingChildResponse() {
    var status = _viewModel.addingChildResponse.status;

    switch (status) {
      case Status.LOADING:
        showAlertDialog(context: context,
            messageDialog: ActionDialog(
          type: DialogType.loading,
          title: "Adding Child",
          message: "pleas wait until process complete..",
          onCompleted: () {},
        ));
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        showAlertDialog(context: context,
            messageDialog: ActionDialog(
          type: DialogType.completed,
          title: "Competed",
          message: "child ${_viewModel.addingChildResponse.data?.name}",
          onCompleted: () {
            Navigator.pop(context);
          },
        ));
        break;
      case Status.ERROR:
        Navigator.pop(context);
        showAlertDialog(context: context,
            messageDialog: ActionDialog(
          type: DialogType.error,
          title: "error",
          message: _viewModel.addingChildResponse.message.toString(),
          onCompleted: () {},
        ));
        break;
      default:
    }
  }
}
