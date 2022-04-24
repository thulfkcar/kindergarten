
import 'package:json_annotation/json_annotation.dart';

import 'UserModel.dart';
part 'Contact.g.dart';

@JsonSerializable()
class Contact{

  String name;
  String phone;
  String? email;
  String userType;
  Contact({required this.name,required this.phone, this.email,required this.userType});
  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}