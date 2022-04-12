import 'package:json_annotation/json_annotation.dart';

part 'HomeModel.g.dart';
@JsonSerializable()
class HomeModel {
  int todayActions;
  int staffCount;
  int parentCount;
  int childrenCount;

  HomeModel({
      required this.todayActions, required this.staffCount, required this.parentCount, required this.childrenCount});
  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}
