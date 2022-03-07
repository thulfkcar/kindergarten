
import 'ChildAction.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ActionGroup.g.dart';
@JsonSerializable()
class ActionGroup {
  String id;
  String actionName;
  bool? active;
  String? image;

  ActionGroup(
      {required this.image,
       required this.id,
      required this.actionName,
      this.active});

  factory ActionGroup.fromJson(Map<String, dynamic> json) => _$ActionGroupFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ActionGroupToJson(this);
}
