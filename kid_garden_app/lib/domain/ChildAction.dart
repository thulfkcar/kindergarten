import 'package:json_annotation/json_annotation.dart';

import 'Media.dart';
part 'ChildAction.g.dart';

@JsonSerializable()
class ChildAction {
  String id;
  String childId;
  @JsonKey(name: 'actionListId')
  String actionGroupId;
  @JsonKey(name: 'actionName')
  String? actionGroupName;
  String value;
  String userId;
  String? userName;
  Audience audience;
  DateTime? date;
  List<String>? images;
  @JsonKey(name: 'mediaDto')
  List<Media>? medias;

  ChildAction(
      {required this.id,
      required this.childId,
      required this.actionGroupId,
      required this.value,
      required this.userId,
      this.userName,
      required this.audience,
      required this.date,
      this.actionGroupName});

  factory ChildAction.fromJson(Map<String, dynamic> json) =>
      _$ChildActionFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ChildActionToJson(this);
}

enum Audience {
  @JsonValue(0)
  All,
  @JsonValue(1)
  Parents,
  @JsonValue(2)
  Staff,
  @JsonValue(3)
  OnlyMe
}
