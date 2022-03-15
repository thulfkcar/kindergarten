import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Child.dart';

part 'User.g.dart';

@JsonSerializable()
class User {


  String? id;
  String? name;
  String? email;
  Role role;
  String token;
  int? tokenExpire;
  int? refreshExpire;
  String? image;



  User(this.id,  this.name, this.email, this.role, this.token,
      this.refreshExpire, this.tokenExpire);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return '{"id": "$id", "name": "$name", "email": "$email", "role": ${role.index}, "token": "$token", "tokenExpire": $tokenExpire, "refreshExpire": $refreshExpire, "image": "$image"}';
  }

// @override
// String toString() {
//   return '{"id": "$id", "date": "$date", "name": "$name", "email": "$email", "role": "$role","token": $token,"tokenExpire": $tokenExpire, "image": $image}';
// }

}
enum Role {
  @JsonValue(0)
  admin,
  @JsonValue(1)
  Staff,
  @JsonValue(2)
  Parents,
}
