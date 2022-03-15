import 'package:json_annotation/json_annotation.dart';
part 'Media.g.dart';

@JsonSerializable()
class Media {
  @JsonKey(name: 'mediaId')
  String id;
  String url;
  MediaType mediaType;

  Media(this.id, this.url, this.mediaType);

  factory Media.fromJson(Map<String, dynamic> json) =>
      _$MediaFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MediaToJson(this);
}

enum MediaType {
  @JsonValue(0)
  image,
  @JsonValue(1)
  video
}
