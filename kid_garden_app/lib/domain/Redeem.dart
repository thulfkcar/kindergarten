import 'package:json_annotation/json_annotation.dart';

part 'Redeem.g.dart';

@JsonSerializable()
class Redeem {
  bool used;
  int duration;
  bool expired;
  DateTime expirationDate;
  bool durationExceeded;
  int remainingDays;
  String subscriptionBatchId;
  DateTime scratchDate;

  Redeem(
      {required this.used,
      required this.duration,
      required this.expired,
      required this.expirationDate,
      required this.durationExceeded,
      required this.remainingDays,
      required this.subscriptionBatchId,
      required this.scratchDate});


  factory Redeem.fromJson(Map<String, dynamic> json) =>
      _$RedeemFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RedeemToJson(this);
}
