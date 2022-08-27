// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      role: fields[3] as Role,
      token: fields[4] as String?,
      refreshExpire: fields[6] as int?,
      tokenExpire: fields[5] as int?,
      stringRole: fields[8] as String?,
      phone: fields[9] as String?,
      childrenCount: fields[10] as int?,
      actionsCount: fields[11] as int?,
    )..image = fields[7] as String?;
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.token)
      ..writeByte(5)
      ..write(obj.tokenExpire)
      ..writeByte(6)
      ..write(obj.refreshExpire)
      ..writeByte(7)
      ..write(obj.image)
      ..writeByte(8)
      ..write(obj.stringRole)
      ..writeByte(9)
      ..write(obj.phone)
      ..writeByte(10)
      ..write(obj.childrenCount)
      ..writeByte(11)
      ..write(obj.actionsCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RoleAdapter extends TypeAdapter<Role> {
  @override
  final int typeId = 2;

  @override
  Role read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Role.superAdmin;
      case 1:
        return Role.admin;
      case 2:
        return Role.Staff;
      case 3:
        return Role.Parents;
      default:
        return Role.superAdmin;
    }
  }

  @override
  void write(BinaryWriter writer, Role obj) {
    switch (obj) {
      case Role.superAdmin:
        writer.writeByte(0);
        break;
      case Role.admin:
        writer.writeByte(1);
        break;
      case Role.Staff:
        writer.writeByte(2);
        break;
      case Role.Parents:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
