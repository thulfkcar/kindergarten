import 'package:json_annotation/json_annotation.dart';

import 'Child.dart';
import 'Kindergraten.dart';
import 'UserModel.dart';

part 'AssignRequest.g.dart';

@JsonSerializable()
class AssignRequest {
  String? message;
  DateTime date;
  DateTime? reactDate;
  int? childAge;
  String? kindergartenName;
  String? kindergartenId;
  String? kindergartenImage;
  String adminName;
  String? adminId;
  String? parentName;
  String? parentId;
  String? childName;
  String? childId;
  String? childImage;
  RequestStatus requestStatus;

  AssignRequest({
    required this.requestStatus,
      this.message,
      required this.date,
      required this.childAge,
      required this.kindergartenName,
      this.kindergartenId,
      required this.kindergartenImage,
      required this.adminName,
      this.adminId,
      required this.parentName,
      this.parentId,
      required this.childName,
      required this.childId,
      required this.childImage});

  factory AssignRequest.fromJson(Map<String, dynamic> json) =>
      _$AssignRequestFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AssignRequestToJson(this);
}

enum RequestStatus {
  @JsonValue(1)
  Pending,
  @JsonValue(2)
  Joined,
  @JsonValue(3)
  Rejected,
}
