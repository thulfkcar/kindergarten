import 'dart:io';

import 'package:kid_garden_app/domain/UserModel.dart';

class StaffAddingForm {
  String? email;
  String? password;
  String? name;
  Role role = Role.Staff;
  File? image;
  DateTime? birthDate;

  String? phoneNumber;
}
