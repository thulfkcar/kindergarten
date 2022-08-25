// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Kindergarten.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kindergarten _$KindergartenFromJson(Map<String, dynamic> json) => Kindergarten(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      location: json['location'] as String,
      latitudes: (json['latitudes'] as num).toDouble(),
      longitudes: (json['longitudes'] as num).toDouble(),
      phone: json['phone'] as String,
      ditance: json['ditance'] as String?,
      media: json['media'] == null
          ? null
          : Media.fromJson(json['media'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KindergartenToJson(Kindergarten instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'location': instance.location,
      'latitudes': instance.latitudes,
      'longitudes': instance.longitudes,
      'phone': instance.phone,
      'ditance': instance.ditance,
      'media': instance.media,
    };
