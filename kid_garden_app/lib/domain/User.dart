import 'package:kid_garden_app/domain/ActionGroup.dart';
import 'package:json_annotation/json_annotation.dart';

import 'Child.dart';
part 'User.g.dart';

@JsonSerializable()
class User {
  String id;
  DateTime date;
  String name;

  String email;


  String role;

  List<ActionGroup> actionGroups;

  List<Child> children;

  User(this.id, this.date, this.name, this.email, this.role,
      this.actionGroups, this.children);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
