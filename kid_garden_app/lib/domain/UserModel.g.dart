// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['id'] as String?,
      json['name'] as String?,
      json['email'] as String?,
      $enumDecode(_$RoleEnumMap, json['role']),
      json['token'] as String?,
      json['refresh_expire'] as int?,
      json['token_expire'] as int?,
      json['string_role'] as String?,
    )
      ..image = json['image'] as String?
      ..childrenCount = json['children_count'] as int?
      ..actionsCount = json['actions_count'] as int?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': _$RoleEnumMap[instance.role],
      'token': instance.token,
      'token_expire': instance.tokenExpire,
      'refresh_expire': instance.refreshExpire,
      'image': instance.image,
      'string_role': instance.stringRole,
      'children_count': instance.childrenCount,
      'actions_count': instance.actionsCount,
    };

const _$RoleEnumMap = {
  Role.superAdmin: -1,
  Role.admin: 0,
  Role.Staff: 1,
  Role.Parents: 2,
};
