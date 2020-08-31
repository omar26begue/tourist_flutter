// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitios_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SitiosModel _$SitiosModelFromJson(Map<String, dynamic> json) {
  return SitiosModel(
    idsitio: json['idsitio'] as String,
    nombre: json['nombre'] as String,
    ubicacion: json['ubicacion'] as String,
    distancia: (json['distancia'] as num)?.toDouble(),
    tiempo: json['tiempo'] as int,
    poblacion: json['poblacion'] as int,
    descripcion: json['descripcion'] as String,
    hora_apertura: json['hora_apertura'] as String,
    hora_cierre: json['hora_cierre'] as String,
    imagenes: (json['imagenes'] as List)
        ?.map((e) => e == null
            ? null
            : ImagenesModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    opciones: json['opciones'] as bool,
  );
}

Map<String, dynamic> _$SitiosModelToJson(SitiosModel instance) =>
    <String, dynamic>{
      'idsitio': instance.idsitio,
      'nombre': instance.nombre,
      'ubicacion': instance.ubicacion,
      'descripcion': instance.descripcion,
      'hora_apertura': instance.hora_apertura,
      'hora_cierre': instance.hora_cierre,
      'distancia': instance.distancia,
      'tiempo': instance.tiempo,
      'poblacion': instance.poblacion,
      'imagenes': instance.imagenes,
      'opciones': instance.opciones,
    };
