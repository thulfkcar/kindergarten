import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/data/network/FromData/StaffAddingForm.dart';
import 'package:tuple/tuple.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../data/network/ApiResponse.dart';
import '../../../data/network/FromData/User.dart';
import '../../../di/Modules.dart';
import '../../../domain/Child.dart';
import '../../../domain/User.dart';
import '../../utile/FormValidator.dart';
import '../general_components/ActionDialog.dart';
import '../general_components/ComboBoxDental2.dart';
import 'StaffViewModel.dart';

class StaffAdding extends ConsumerStatefulWidget {
  StaffAdding({
    Key? key,
  }) : super(key: key);
  AssetEntity? imagePath;

  @override
  ConsumerState createState() => _ChildAddingScreenState();
}

class _ChildAddingScreenState extends ConsumerState<StaffAdding> {
  late StaffViewModel _viewModel;
  TextEditingController nameController = TextEditingController();
  List role = [Role.Staff, Role.Parents,Role.admin];
  ScrollController scrollController = ScrollController();
  DateTime selectedDate = DateTime.now().toUtc();
  String message = "";
  Role selectedGender = Role.Staff;

  final StaffAddingForm _staffAddingForm = StaffAddingForm();
  final GlobalKey<FormState> _key = GlobalKey();

  AutovalidateMode _validate = AutovalidateMode.disabled;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(staffViewModelProvider);
    Future.delayed(Duration.zero, () async {
      postingChildResponse();
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Add Staff",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Form(
            key: _key,
            autovalidateMode: _validate,
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
                        TextFormField(
                          onChanged: ((text) => _staffAddingForm.name = text),
                          keyboardType: TextInputType.name,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: "ahmed adnan",
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                          validator: FormValidator(context).validateNotEmpty,
                          onSaved: (String? value) {
                            _staffAddingForm.name = value!;
                          },
                        ),
                        Padding(padding: EdgeInsets.all(8)),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFF898989), width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
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
                                      style:
                                          TextStyle(color: Color(0xFF898989)),
                                    ),
                                    Text("${selectedDate.toLocal()}"
                                        .split(' ')[0])
                                  ])),
                                ],
                              )),
                        ),
                        Padding(padding: EdgeInsets.all(8)),
                        TextFormField(
                          onChanged: ((text) => _staffAddingForm.email = text),
                          keyboardType: TextInputType.emailAddress,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: "email@eamil.com",
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                          validator: FormValidator(context).validateEmail,
                          onSaved: (String? value) {
                            _staffAddingForm.email = value!;
                          },
                        ),
                        Padding(padding: EdgeInsets.all(8)),

                        TextFormField(
                          onChanged: ((text) => _staffAddingForm.phoneNumber = text),
                          keyboardType: TextInputType.phone,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: "07803497103",
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 15.0, 20.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                          validator: FormValidator(context).validatePhone,
                          onSaved: (String? value) {
                            _staffAddingForm.phoneNumber = value!;
                          },
                        ),
                        Padding(padding: EdgeInsets.all(8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            addRadioButton(0, 'Admin'),
                            addRadioButton(1, 'Staff'),
                            addRadioButton(2, 'Parent'),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                            child: ElevatedButton(
                              onPressed: () async {
                                await _sendToServer();
                                // Tuple2 result = validateAddChildInputs();
                                // if (result.item1 != null) {
                                //   await _viewModel.addStaff(
                                //       childForm: result.item1);
                                // } else {
                                //   setState(() {
                                //     showAlertDialog(
                                //         messageDialog: ActionDialog(
                                //           type: DialogType.error,
                                //           title: 'Input Validation',
                                //           message: result.item2,
                                //           delay: 4000,
                                //           onCompleted: () {},
                                //         ));
                                //   });
                                // }
                              },
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0.0),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide()))),
                              child: Text("Add"),
                            )),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> showAlertDialog({required ActionDialog messageDialog}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return messageDialog;
      },
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
        Radio<Role>(
          activeColor: Theme.of(context).primaryColor,
          value: role[btnValue],
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

  // Tuple2<StaffAddingForm?, String> validateAddChildInputs() {
  //   if (nameController.text.trim().isEmpty) {
  //     return const Tuple2(null, "pleas enter child name");
  //   }
  //   if (widget.imagePath == null) {
  //     return const Tuple2(null, "please choose poper image");
  //   }
  //   return Tuple2(
  //       StaffAddingForm(
  //           birthDate: selectedDate.toUtc(),
  //           role: Role.Staff, name: nameController.text, password: "4565@1", image: widget.imagePath!, email: "thiggr@gmaifgdlg"),
  //       "adding image scheduled");
  // }
  Future _sendToServer() async {
    if (_key.currentState!.validate()) {
      // await viewModel.auth(loginRequestData: form);
      /// No any error in validation
      _key.currentState!.save();
    } else {
      ///validation error
      setState(() {
        _validate = AutovalidateMode.always;
      });
    }
  }

  void postingChildResponse() {
    var status = _viewModel.addingStaffResponse.status;

    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            messageDialog: ActionDialog(
          type: DialogType.loading,
          title: "Adding Child",
          message: "pleas wait until process complete..",
          onCompleted: () {},
        ));
        break;
      case Status.COMPLETED:
        Navigator.pop(context);
        showAlertDialog(
            messageDialog: ActionDialog(
          type: DialogType.completed,
          title: "Competed",
          message: "child ${_viewModel.addingStaffResponse.data?.name}",
          onCompleted: () {
            Navigator.pop(context);
          },
        ));
        break;
      case Status.ERROR:
        Navigator.pop(context);
        showAlertDialog(
            messageDialog: ActionDialog(
          type: DialogType.error,
          title: "error",
          message: _viewModel.addingStaffResponse.message.toString(),
          onCompleted: () {},
        ));
        break;
      default:
    }
  }
}
