import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usuarios_model.g.dart';

@JsonSerializable()
class UsuariosModel {
  // ignore: non_constant_identifier_names
  String idusuario, rol, nombres, apellido1, apellido2, email, photo, access_token;

  UsuariosModel(
      {this.idusuario,
      @required this.rol,
      @required this.nombres,
      @required this.apellido1,
      this.apellido2,
      @required this.email,
      this.photo,
      // ignore: non_constant_identifier_names
      this.access_token});

  factory UsuariosModel.fromJson(Map<String, dynamic> json) => _$UsuariosModelFromJson(json);

  Map<String, dynamic> toJson() => _$UsuariosModelToJson(this);
}
