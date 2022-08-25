// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MultiResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultiResponse<T> _$MultiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    MultiResponse<T>(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      count: json['count'] as int,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      pages: json['pages'] as int,
    );

Map<String, dynamic> _$MultiResponseToJson<T>(
  MultiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'count': instance.count,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'pages': instance.pages,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
