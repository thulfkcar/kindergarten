import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/network/FromData/User.dart';

class EditProfile extends ConsumerWidget {
  Function(EditUserForm) proceedEditing;
  Function() canceled;

  EditProfile({Key? key, required this.proceedEditing, required this.canceled})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController userNameController = TextEditingController();
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          title: const Text("Edit Information"),
          content: Column(
            children: [
              TextField(
                controller: userNameController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                canceled();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              //todo missing validate before that

              onPressed: () {
                proceedEditing(EditUserForm(
                    userName: userNameController.text));
              },
              child: const Text("Save"),
            )
          ],
        ));
  }
}
