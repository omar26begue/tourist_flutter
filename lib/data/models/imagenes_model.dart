import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'imagenes_model.g.dart';

@JsonSerializable()
class ImagenesModel {
  String idimagenes, idsitio, nombre;
  int calificacion, zoom;
  double lat, lon;

  ImagenesModel({@required this.idimagenes, @required this.idsitio, @required this.nombre, @required this.calificacion, this.lat, this.lon, this.zoom});

  factory ImagenesModel.fromJson(Map<String, dynamic> json) => _$ImagenesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImagenesModelToJson(this);
}
