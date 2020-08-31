// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imagenes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImagenesModel _$ImagenesModelFromJson(Map<String, dynamic> json) {
  return ImagenesModel(
    idimagenes: json['idimagenes'] as String,
    idsitio: json['idsitio'] as String,
    nombre: json['nombre'] as String,
    calificacion: json['calificacion'] as int,
    lat: (json['lat'] as num)?.toDouble(),
    lon: (json['lon'] as num)?.toDouble(),
    zoom: json['zoom'] as int,
  );
}

Map<String, dynamic> _$ImagenesModelToJson(ImagenesModel instance) =>
    <String, dynamic>{
      'idimagenes': instance.idimagenes,
      'idsitio': instance.idsitio,
      'nombre': instance.nombre,
      'calificacion': instance.calificacion,
      'zoom': instance.zoom,
      'lat': instance.lat,
      'lon': instance.lon,
    };
