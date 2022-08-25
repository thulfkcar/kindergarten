// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ErrorResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      status: json['status'] as bool?,
      errorMsg: json['errorMsg'] as String?,
      errorTxt: json['errorTxt'] as String?,
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'errorMsg': instance.errorMsg,
      'errorTxt': instance.errorTxt,
    };
