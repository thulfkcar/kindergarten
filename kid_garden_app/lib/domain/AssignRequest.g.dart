// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AssignRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignRequest _$AssignRequestFromJson(Map<String, dynamic> json) =>
    AssignRequest(
      id: json['id'] as String,
      requestStatus: $enumDecode(_$RequestStatusEnumMap, json['requestStatus']),
      message: json['message'] as String?,
      date: DateTime.parse(json['date'] as String),
      childAge: json['childAge'] as int?,
      kindergartenName: json['kindergartenName'] as String?,
      kindergartenId: json['kindergartenId'] as String?,
      kindergartenImage: json['kindergartenImage'] as String?,
      adminName: json['adminName'] as String?,
      adminId: json['adminId'] as String?,
      parentName: json['parentName'] as String?,
      parentId: json['parentId'] as String?,
      childName: json['childName'] as String?,
      childId: json['childId'] as String?,
      childImage: json['childImage'] as String?,
    )
      ..reactDate = json['reactDate'] == null
          ? null
          : DateTime.parse(json['reactDate'] as String)
      ..gender = $enumDecodeNullable(_$GenderEnumMap, json['gender']);

Map<String, dynamic> _$AssignRequestToJson(AssignRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'date': instance.date.toIso8601String(),
      'reactDate': instance.reactDate?.toIso8601String(),
      'childAge': instance.childAge,
      'kindergartenName': instance.kindergartenName,
      'kindergartenId': instance.kindergartenId,
      'kindergartenImage': instance.kindergartenImage,
      'adminName': instance.adminName,
      'adminId': instance.adminId,
      'parentName': instance.parentName,
      'parentId': instance.parentId,
      'childName': instance.childName,
      'childId': instance.childId,
      'childImage': instance.childImage,
      'gender': _$GenderEnumMap[instance.gender],
      'requestStatus': _$RequestStatusEnumMap[instance.requestStatus],
    };

const _$RequestStatusEnumMap = {
  RequestStatus.Pending: 1,
  RequestStatus.Joined: 2,
  RequestStatus.Rejected: 3,
};

const _$GenderEnumMap = {
  Gender.Male: 0,
  Gender.Female: 1,
};
