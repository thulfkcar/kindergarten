import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_garden_app/data/network/ApiResponse.dart';
import 'package:kid_garden_app/data/network/FromData/ChildForm.dart';
import 'package:kid_garden_app/presentation/styles/colors_style.dart';
import 'package:kid_garden_app/presentation/ui/general_components/units/buttons.dart';
import '../../../di/Modules.dart';
import '../../../domain/Child.dart';
import '../../utile/FormValidator.dart';
import '../../utile/LangUtiles.dart';
import '../general_components/units/texts.dart';
import 'ChildViewModel.dart';
import '../general_components/ActionDialog.dart';

class ChildAddingScreen extends ConsumerStatefulWidget {
  Function(Child?) onAdded;

  ChildAddingScreen({
    required this.onAdded,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ChildAddingScreenState();
}

class _ChildAddingScreenState extends ConsumerState<ChildAddingScreen> {
  File? imagePath;
  late ChildViewModel _viewModel;
  TextEditingController childNameController = TextEditingController();
  List gender = [Gender.Male, Gender.Female];
  ScrollController scrollController = ScrollController();
  Gender selectedGender = Gender.Male;
  DateTime selectedDate = DateTime.now().toUtc();
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String message = "";
  ChildForm form = ChildForm();

  @override
  Widget build(BuildContext context) {
    _viewModel = ref.watch(childViewModelProvider(null));
    Future.delayed(Duration.zero, () async {
      postingResponse();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context)?.getText("add_child") ?? "Add Child"),
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
                                FilePickerResult? result = await FilePicker
                                    .platform
                                    .pickFiles(type: FileType.image);

                                if (result != null) {
                                  File file = File(result.files.single.path!);

                                  setState(() {
                                    form.imageFile = file;
                                  });
                                } else {
                                  // User canceled the picker
                                }
                              },
                              child: form.imageFile != null
                                  ? Container(
                                      height: 150.0,
                                      width: 150.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 1,
                                        ),
                                        image: DecorationImage(
                                          image: FileImage(form.imageFile!),
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
                                child: Text(
                                  AppLocalizations.of(context)
                                          ?.getText("tap_add_image") ??
                                      "Tap to add or change Image",
                                ))
                          ],
                        ),
                      ),
                      customTextForm(
                          icon: Icon(Icons.person),
                          textType: TextInputType.name,
                          onSaved: (value) {
                            form.childName = value!;
                          },
                          hint: '',
                          onChange: (value) {
                            form.childName = value;
                          },
                          validator: FormValidator(context).validateNotEmpty),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          addRadioButton(
                              0,
                              AppLocalizations.of(context)?.getText("male") ??
                                  'Male'),
                          addRadioButton(
                              1,
                              AppLocalizations.of(context)?.getText("female") ??
                                  'Female'),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFF898989), width: 2),
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
                                  Text(
                                    AppLocalizations.of(context)
                                            ?.getText("birth_date") ??
                                        "Birth Date:      ",
                                    style: TextStyle(color: Color(0xFF898989)),
                                  ),
                                  Text(
                                      "${selectedDate.toLocal()}".split(' ')[0])
                                ])),
                              ],
                            )),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 100, 0, 10),
                          child: customButton(
                              text: AppLocalizations.of(context)
                                      ?.getText("add") ??
                                  "Add",
                              icon: Icons.add,
                              mainColor: ColorStyle.text1,
                              backgroundColor: ColorStyle.male1,
                              onPressed: () async {
                                await _sendToServer();
                              })),

                      // child: ElevatedButton(
                      //   onPressed: () async {
                      //     await _sendToServer();
                      //   },
                      //   style: ButtonStyle(
                      //       elevation: MaterialStateProperty.all(0.0),
                      //       backgroundColor: MaterialStateProperty.all(
                      //           Colors.transparent),
                      //       shape: MaterialStateProperty.all<
                      //               RoundedRectangleBorder>(
                      //           RoundedRectangleBorder(
                      //               borderRadius:
                      //                   BorderRadius.circular(18.0),
                      //               side: BorderSide()))),
                      //   child: Text("Add"),
                      // ))
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        form.birthDate = picked.toUtc();
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
              selectedGender = gender!;
              form.gender = gender.index;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  Future _sendToServer() async {
    if (form.imageFile != null) {
      if (_key.currentState!.validate()) {
        await _viewModel.addChild(childForm: form);

        /// No any error in validation
        _key.currentState!.save();
      } else {
        ///validation error
        setState(() {
          _validate = AutovalidateMode.always;
        });
      }
    } else {
      showAlertDialog(
          messageDialog: ActionDialog(
              type: DialogType.warning,
              title: AppLocalizations.of(context)?.getText("image") ?? "image",
              message:
                  AppLocalizations.of(context)?.getText("image_required") ??
                      "Image Required"));
    }
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

  void postingResponse() {
    var status = _viewModel.addingChildResponse.status;

    switch (status) {
      case Status.LOADING:
        showAlertDialog(
            messageDialog: ActionDialog(
          type: DialogType.loading,
          title: AppLocalizations.of(context)?.getText("add_child") ??
              "Adding Child",
          message: AppLocalizations.of(context)?.getText("adding_child_des") ??
              "please wait until process complete..",
          onCompleted: (s) {},
        ));
        _viewModel.addingChildResponse = ApiResponse.non();
        break;

      case Status.COMPLETED:
        var date = _viewModel.addingChildResponse.data;
        Navigator.pop(context);
        showAlertDialog(
            messageDialog: ActionDialog(
          type: DialogType.completed,
          title:
              AppLocalizations.of(context)?.getText("add_child") ?? "Competed",
          message: "${_viewModel.addingChildResponse.data?.name}",
          onCompleted: (s) {
            Navigator.pop(context);
          },
        ));
        widget.onAdded(date);

        _viewModel.addingChildResponse = ApiResponse.non();
        break;
      case Status.ERROR:
        Navigator.pop(context);
        showAlertDialog(
            messageDialog: ActionDialog(
          type: DialogType.error,
          title: AppLocalizations.of(context)?.getText("add_child") ??
              "Adding Child",
          message: _viewModel.addingChildResponse.message.toString(),
          onCompleted: (s) {
            // _viewModel.addingChildResponse = ApiResponse.non();
          },
        ));
        _viewModel.addingChildResponse = ApiResponse.non();

        break;
      default:
    }
  }
}
