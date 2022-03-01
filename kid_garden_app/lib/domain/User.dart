import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Child.dart';
part 'User.g.dart';

@JsonSerializable()
class User {
  String? id;
  DateTime? date;
  String? name;
  String? email;
  int? role;
  String? token;
  int? tokenExpire;
  int? refreshExpire;
  String? image;
  List<ActionGroup>? actionGroups;
  List<Child>? children;
  User(this.id, this.date, this.name, this.email, this.role, this.token,this.refreshExpire,this.tokenExpire);
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return '{"id": "$id", "date": "$date", "name": "$name", "email": "$email", "role": "$role"}';
  }
}
