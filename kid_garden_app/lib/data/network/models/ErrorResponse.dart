import 'package:json_annotation/json_annotation.dart';

part 'ErrorResponse.g.dart';

@JsonSerializable()
class ErrorResponse{

 bool? status;
 String? errorMsg;

 ErrorResponse({this.status, this.errorMsg});

 factory ErrorResponse.fromJson(Map<String, dynamic> json) => _$ErrorResponseFromJson(json);


}