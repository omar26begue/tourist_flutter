import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_login.g.dart';

@JsonSerializable()
class RequestLogin {
  String email, password;

  RequestLogin({@required this.email, @required this.password});

  factory RequestLogin.fromJson(Map<String, dynamic> json) => _$RequestLoginFromJson(json);

  Map<String, dynamic> toJson() => _$RequestLoginToJson(this);
}