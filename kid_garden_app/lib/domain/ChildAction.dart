import 'package:kid_garden_app/domain/ActionGroup.dart';

import 'package:json_annotation/json_annotation.dart';

import 'User.dart';
part 'ChildAction.g.dart';
@JsonSerializable()
class ChildAction {
  String id;
  DateTime? date;

  String actionGroupId;
  ActionGroup? actionGroup;
  String value;

  User? user;



  Audience? audience;

  ChildAction({required this.id, this.date,
    required this.actionGroupId,
      required this.value, this.user,
       this.audience, this.actionGroup});

  factory ChildAction.fromJson(Map<String, dynamic> json) => _$ChildActionFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ChildActionToJson(this);
}
enum Audience { @JsonValue(1)All, @JsonValue(2)Parents, @JsonValue(3)Staff, @JsonValue(4)OnlyMe }
