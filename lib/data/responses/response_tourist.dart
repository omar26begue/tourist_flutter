import 'package:json_annotation/json_annotation.dart';

part 'response_tourist.g.dart';

@JsonSerializable()
class ResponseTourist {
  int status;
  String message;
  String error;
  dynamic data;

  ResponseTourist(this.status, this.message, this.error, this.data);

  factory ResponseTourist.fromJson(Map<String, dynamic> json) => _$ResponseTouristFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseTouristToJson(this);
}
