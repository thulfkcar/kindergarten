// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HomeModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModel _$HomeModelFromJson(Map<String, dynamic> json) => HomeModel(
      todayActions: json['todayActions'] as int,
      staffCount: json['staffCount'] as int,
      parentCount: json['parentCount'] as int,
      childrenCount: json['childrenCount'] as int,
    );

Map<String, dynamic> _$HomeModelToJson(HomeModel instance) => <String, dynamic>{
      'todayActions': instance.todayActions,
      'staffCount': instance.staffCount,
      'parentCount': instance.parentCount,
      'childrenCount': instance.childrenCount,
    };
