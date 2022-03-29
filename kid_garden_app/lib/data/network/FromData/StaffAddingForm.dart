import 'package:kid_garden_app/domain/UserModel.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class StaffAddingForm {
  String? email;
  String? password;
  String? name;
  Role role = Role.Staff;
  AssetEntity? image;
  DateTime? birthDate;

  String? phoneNumber;
}
