import 'package:json_annotation/json_annotation.dart';
part 'UserModel.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UserModel {
  String? id;
  String? name;
  String? email;
  Role role;
  String? token;
  int? tokenExpire;
  int? refreshExpire;
  String? image;
  String? stringRole;
  String? phone;
  int? childrenCount;
  int? actionsCount;

  UserModel({this.id, this.name, this.email, required this.role, this.token,
      this.refreshExpire, this.tokenExpire,this.stringRole,this.phone, required this.childrenCount, required this.actionsCount});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return '{"id": "$id", "name": "$name", "email": "$email", "role": ${role.index-1}, "token": "$token", "tokenExpire": $tokenExpire, "refreshExpire": $refreshExpire, "image": "$image","phone":"$phone"}';
  }

// @override
// String toString() {
//   return '{"id": "$id", "date": "$date", "name": "$name", "email": "$email", "role": "$role","token": $token,"tokenExpire": $tokenExpire, "image": $image}';
// }

}

enum Role {
  @JsonValue(-1)
  superAdmin,
  @JsonValue(0)
  admin,
  @JsonValue(1)
  Staff,
  @JsonValue(2)
  Parents,
}
