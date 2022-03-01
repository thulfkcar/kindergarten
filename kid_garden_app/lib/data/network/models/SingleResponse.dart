import 'package:json_annotation/json_annotation.dart';

part 'SingleResponse.g.dart';

@JsonSerializable(genericArgumentFactories: true)
 class SingleResponse<T>  {
  final bool? status;
  final String? message;
  final T? data;

  SingleResponse({this.status, this.message, this.data});

  factory SingleResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  )  =>
      _$SingleResponseFromJson(json,  fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$SingleResponseToJson(this, toJsonT);
}
