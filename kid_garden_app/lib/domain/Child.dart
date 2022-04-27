import 'package:kid_garden_app/domain/AssignRequest.dart';
import 'package:kid_garden_app/domain/Kindergraten.dart';

import 'ChildAction.dart';
import 'Contact.dart';
import 'UserModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Child.g.dart';

@JsonSerializable()
class Child {
  String name;
  String id;
  String? image;
  DateTime? birthDate;
  Gender? gender;
  int? age;
  List<ChildAction>? childActions;
  UserModel? user;
  String? mediaId;
  String? staffName;
  String? kindergartenId;
  Kindergraten? kindergraten;
  List<Contact>? contacts;
  AssignRequest? assignRequest;
  Child(
      {required this.name,
      required this.id,
      required this.image,
      this.gender,
      this.age,
      this.birthDate,
      this.childActions,
      this.user,this.contacts});

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ChildToJson(this);
}

enum Gender {
  @JsonValue(0)
  Male,
  @JsonValue(1)
  Female,
}
