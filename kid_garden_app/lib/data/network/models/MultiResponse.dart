import 'package:json_annotation/json_annotation.dart';
part 'MultiResponse.g.dart';
@JsonSerializable()
class MultiResponse {
  bool? status;
  String? message;
  int? count;
  String? data;
  int? pages;

  MultiResponse({this.status, this.message, this.count, this.data, this.pages});


  factory MultiResponse.fromJson(Map<String, dynamic> json) => _$MultiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MultiResponseToJson(this);
}