import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kid_garden_app/data/network/FromData/User.dart';

import '../../../utile/FormValidator.dart';

class AddStaff extends ConsumerStatefulWidget {
  Function() canceled;
  Function(AddUserForm) proceedAdding;

  AddStaff({Key? key, required this.canceled, required this.proceedAdding})
      : super(key: key);

  @override
  ConsumerState createState() => _AddStaffState();
}

class _AddStaffState extends ConsumerState<AddStaff> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Form(
            key: _formKey,
            child: AlertDialog(
              title: const Text("Edit Information"),
              content: Column(
                children: [
                  TextFormField(
                    controller: userNameController,
                    validator: (value) =>
                        FormValidator(context).validateEmail(value),
                    onSaved: (String? value) {
                      print(value);
                    },
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
                        label: const Text("user name")),
                    maxLines: 1,
                  ),
                  TextFormField(
                    validator: FormValidator(context).validatePassword,
                    onSaved: (String? value) {
                      print(value);
                    },
                    controller: passwordController,
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
                        hintText: "RxulB123@a....",
                        label: const Text("Password")),
                    maxLines: 1,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value != passwordController.text) {
                        return 'Passwords not Matched';
                      }
                      return null;
                    },
                    controller: rePasswordController,
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
                        hintText: "RxulB123@a....",
                        label: const Text("Re_Password")),
                    maxLines: 1,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    widget.canceled();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  //todo missing validate before that

                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.proceedAdding(AddUserForm(
                          userName: userNameController.text,
                          password: passwordController.text,
                          role: "staff"));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text("Save"),
                )
              ],
            )));
  }
}
