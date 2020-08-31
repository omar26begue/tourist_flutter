// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_tourist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseTourist _$ResponseTouristFromJson(Map<String, dynamic> json) {
  return ResponseTourist(
    json['status'] as int,
    json['message'] as String,
    json['error'] as String,
    json['data'],
  );
}

Map<String, dynamic> _$ResponseTouristToJson(ResponseTourist instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'error': instance.error,
      'data': instance.data,
    };
