import 'package:json_annotation/json_annotation.dart';

part 'ErrorResponse.g.dart';

@JsonSerializable()
class ErrorResponse{

 bool? status;
 String? errorMsg;
 String? errorTxt;

 ErrorResponse({this.status, this.errorMsg, this.errorTxt});

 factory ErrorResponse.fromJson(Map<String, dynamic> json) => _$ErrorResponseFromJson(json);


}