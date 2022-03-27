import 'package:json_annotation/json_annotation.dart';
import 'package:kid_garden_app/domain/Media.dart';
part 'Kindergraten.g.dart';

@JsonSerializable()
class Kindergraten{

String id;
String name;
String? description;
String location;
double latitudes;
double longitudes;
String phone;
String ditance;
Media? media;

Kindergraten({required this.id, required this.name, this.description, required this.location,
      required this.latitudes, required this.longitudes, required this.phone, required this.ditance, required this.media});

factory Kindergraten.fromJson(Map<String, dynamic> json) =>
    _$KindergratenFromJson(json);

/// Connect the generated [_$PersonToJson] function to the `toJson` method.
Map<String, dynamic> toJson() => _$KindergratenToJson(this);
}