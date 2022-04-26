
import 'package:json_annotation/json_annotation.dart';

import 'Child.dart';
import 'Kindergraten.dart';
import 'UserModel.dart';

part 'AssignRequest.g.dart';

@JsonSerializable()
class AssignRequest {
  String id;

  AssignRequest(this.id, this.requestStatus, this.kindergarten, this.message,
      this.admin, this.parent, this.date, this.reactDate, this.child);

  RequestStatus requestStatus;
  Kindergraten kindergarten;
  String? message;
  UserModel? admin;
  UserModel? parent;
  DateTime date;
  DateTime? reactDate;
  Child? child;

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