// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChildAction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildAction _$ChildActionFromJson(Map<String, dynamic> json) => ChildAction(
      id: json['id'] as String,
      childName: json['childName'] as String?,
      childId: json['childId'] as String,
      actionGroupId: json['actionListId'] as String,
      value: json['value'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String?,
      audience: $enumDecode(_$AudienceEnumMap, json['audience']),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      actionGroupName: json['actionName'] as String?,
    )
      ..images =
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..medias = (json['mediaDto'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ChildActionToJson(ChildAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'actionListId': instance.actionGroupId,
      'actionName': instance.actionGroupName,
      'value': instance.value,
      'childName': instance.childName,
      'userId': instance.userId,
      'userName': instance.userName,
      'audience': _$AudienceEnumMap[instance.audience],
      'date': instance.date?.toIso8601String(),
      'images': instance.images,
      'mediaDto': instance.medias,
    };

const _$AudienceEnumMap = {
  Audience.All: 0,
  Audience.Parents: 1,
  Audience.Staff: 2,
  Audience.OnlyMe: 3,
};
