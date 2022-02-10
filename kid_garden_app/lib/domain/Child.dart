import 'ChildAction.dart';
import 'User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Child.g.dart';

@JsonSerializable()
class Child {
  String name;
  String id;
  String image;
  DateTime? date;
  Gender? gender;
  int? age;
  DateTime? birthDate;
  List<ChildAction>? childActions;
  User? user;

  Child(
      {required this.name,
      required this.id,
      required this.image,
      this.date,
      this.gender,
      this.age,
      this.birthDate,
      this.childActions,
      this.user});

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ChildToJson(this);
}

enum Gender {
  @JsonValue(1)
  Male,
  @JsonValue(2)
  Female,
}
