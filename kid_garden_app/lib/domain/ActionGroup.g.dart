// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ActionGroup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionGroup _$ActionGroupFromJson(Map<String, dynamic> json) => ActionGroup(
      image: json['image'] as String?,
      id: json['id'] as String,
      actionName: json['actionName'] as String,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$ActionGroupToJson(ActionGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actionName': instance.actionName,
      'active': instance.active,
      'image': instance.image,
    };
