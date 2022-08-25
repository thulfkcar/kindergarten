// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Child.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Child _$ChildFromJson(Map<String, dynamic> json) => Child(
      name: json['name'] as String,
      id: json['id'] as String,
      image: json['image'] as String?,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      age: json['age'] as int?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      childActions: (json['childActions'] as List<dynamic>?)
          ?.map((e) => ChildAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      contacts: (json['contacts'] as List<dynamic>?)
          ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
      kindergartenName: json['kindergartenName'] as String?,
    )
      ..mediaId = json['mediaId'] as String?
      ..staffName = json['staffName'] as String?
      ..kindergartenId = json['kindergartenId'] as String?
      ..assignRequest = json['assignRequest'] == null
          ? null
          : AssignRequest.fromJson(
              json['assignRequest'] as Map<String, dynamic>);

Map<String, dynamic> _$ChildToJson(Child instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'image': instance.image,
      'birthDate': instance.birthDate?.toIso8601String(),
      'gender': _$GenderEnumMap[instance.gender],
      'age': instance.age,
      'childActions': instance.childActions,
      'user': instance.user,
      'mediaId': instance.mediaId,
      'staffName': instance.staffName,
      'kindergartenId': instance.kindergartenId,
      'kindergartenName': instance.kindergartenName,
      'contacts': instance.contacts,
      'assignRequest': instance.assignRequest,
    };

const _$GenderEnumMap = {
  Gender.Male: 0,
  Gender.Female: 1,
};
