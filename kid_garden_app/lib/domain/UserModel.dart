import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
part 'UserModel.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
@HiveType(typeId: 1,adapterName: "UserModelAdapter")

class UserModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  Role role;
  @HiveField(4)
  String? token;
  @HiveField(5)
  int? tokenExpire;
  @HiveField(6)
  int? refreshExpire;
  @HiveField(7)
  String? image;
  @HiveField(8)
  String? stringRole;
  @HiveField(9)
  String? phone;
  @HiveField(10)
  int? childrenCount;
  @HiveField(11)
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
@HiveType(typeId: 2)

enum Role {
  @JsonValue(-1)
  @HiveField(-1)
  superAdmin,
  @JsonValue(0)
  @HiveField(0)
  admin,
  @JsonValue(1)
  @HiveField(1)
  Staff,
  @JsonValue(2)
  @HiveField(2)
  Parents,
}
