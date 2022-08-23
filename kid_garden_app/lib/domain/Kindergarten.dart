import 'package:json_annotation/json_annotation.dart';
import 'package:kid_garden_app/domain/Media.dart';
part 'Kindergarten.g.dart';

@JsonSerializable()
class Kindergarten{

String id;
String name;
String? description;
String location;
double latitudes;
double longitudes;
String phone;
String? ditance;
Media? media;

Kindergarten({required this.id, required this.name, this.description, required this.location,
      required this.latitudes, required this.longitudes, required this.phone, required this.ditance, required this.media});

factory Kindergarten.fromJson(Map<String, dynamic> json) =>
    _$KindergartenFromJson(json);

/// Connect the generated [_$PersonToJson] function to the `toJson` method.
Map<String, dynamic> toJson() => _$KindergartenToJson(this);
}