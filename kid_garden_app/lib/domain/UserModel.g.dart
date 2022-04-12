// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: $enumDecode(_$RoleEnumMap, json['role']),
      token: json['token'] as String?,
      refreshExpire: json['refreshExpire'] as int?,
      tokenExpire: json['tokenExpire'] as int?,
      stringRole: json['stringRole'] as String?,
      phone: json['phone'] as String?,
      childrenCount: json['childrenCount'] as int?,
      actionsCount: json['actionsCount'] as int?,
    )..image = json['image'] as String?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': _$RoleEnumMap[instance.role],
      'token': instance.token,
      'tokenExpire': instance.tokenExpire,
      'refreshExpire': instance.refreshExpire,
      'image': instance.image,
      'stringRole': instance.stringRole,
      'phone': instance.phone,
      'childrenCount': instance.childrenCount,
      'actionsCount': instance.actionsCount,
    };

const _$RoleEnumMap = {
  Role.superAdmin: -1,
  Role.admin: 0,
  Role.Staff: 1,
  Role.Parents: 2,
};
