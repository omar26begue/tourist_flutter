import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comentarios_model.g.dart';

@JsonSerializable()
class ComentariosModel {
  String idcomentarios, texto, idusuario, fecha, fullname;

  ComentariosModel({this.idcomentarios, @required this.texto, this.idusuario, this.fecha, this.fullname});

  factory ComentariosModel.fromJson(Map<String, dynamic> json) => _$ComentariosModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComentariosModelToJson(this);
}