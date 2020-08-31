import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tourist_flutter/data/models/imagenes_model.dart';

part 'sitios_model.g.dart';

@JsonSerializable()
class SitiosModel {
  String idsitio, nombre, ubicacion, descripcion, hora_apertura, hora_cierre;
  double distancia;
  int tiempo, poblacion;
  List<ImagenesModel> imagenes;
  bool opciones = false;

  SitiosModel(
      {this.idsitio,
      @required this.nombre,
      @required this.ubicacion,
      @required this.distancia,
      @required this.tiempo,
      @required this.poblacion,
      @required this.descripcion,
      @required this.hora_apertura,
      @required this.hora_cierre,
      this.imagenes,
      this.opciones});

  factory SitiosModel.fromJson(Map<String, dynamic> json) => _$SitiosModelFromJson(json);

  Map<String, dynamic> toJson() => _$SitiosModelToJson(this);
}
