import 'package:json_annotation/json_annotation.dart';
part 'MultiResponse.g.dart';
@JsonSerializable(genericArgumentFactories: true)
class MultiResponse<T> {
  bool? status;
  String? message;
  int count;
  T? data;
  int pages;

  MultiResponse({this.status, this.message,required this.count, this.data ,required this.pages});


  factory MultiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      )  =>
      _$MultiResponseFromJson(json,  fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$MultiResponseToJson(this, toJsonT);
}