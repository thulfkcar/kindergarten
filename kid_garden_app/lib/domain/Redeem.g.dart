// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Redeem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Redeem _$RedeemFromJson(Map<String, dynamic> json) => Redeem(
      used: json['used'] as bool,
      duration: json['duration'] as int,
      expired: json['expired'] as bool,
      expirationDate: DateTime.parse(json['expirationDate'] as String),
      durationExceeded: json['durationExceeded'] as bool,
      remainingDays: json['remainingDays'] as int,
      subscriptionBatchId: json['subscriptionBatchId'] as String,
      scratchDate: DateTime.parse(json['scratchDate'] as String),
    );

Map<String, dynamic> _$RedeemToJson(Redeem instance) => <String, dynamic>{
      'used': instance.used,
      'duration': instance.duration,
      'expired': instance.expired,
      'expirationDate': instance.expirationDate.toIso8601String(),
      'durationExceeded': instance.durationExceeded,
      'remainingDays': instance.remainingDays,
      'subscriptionBatchId': instance.subscriptionBatchId,
      'scratchDate': instance.scratchDate.toIso8601String(),
    };
