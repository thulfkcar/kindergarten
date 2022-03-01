
import 'ChildAction.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ActionGroup.g.dart';
@JsonSerializable()
class ActionGroup {
  String id;
  DateTime date;
  String name;
  bool? active;
  String image;
  List<ChildAction>? childActions;
  List<String>? dropDown;
  ActionListType? actionListType;

  ActionGroup(
      {required this.image,
       required this.id,
      required this.date,
      required this.name,
      this.active,
      this.childActions,
      this.dropDown,
      this.actionListType});

  factory ActionGroup.fromJson(Map<String, dynamic> json) => _$ActionGroupFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ActionGroupToJson(this);
}
enum ActionListType { @JsonValue(1)DropDown, @JsonValue(1)Static }
