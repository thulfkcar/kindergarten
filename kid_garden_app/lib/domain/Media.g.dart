// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      json['mediaId'] as String,
      json['url'] as String,
      $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
    );

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'mediaId': instance.id,
      'url': instance.url,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType],
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 0,
  MediaType.video: 1,
};
