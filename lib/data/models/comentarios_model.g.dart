// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comentarios_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComentariosModel _$ComentariosModelFromJson(Map<String, dynamic> json) {
  return ComentariosModel(
    idcomentarios: json['idcomentarios'] as String,
    texto: json['texto'] as String,
    idusuario: json['idusuario'] as String,
    fecha: json['fecha'] as String,
    fullname: json['fullname'] as String,
  );
}

Map<String, dynamic> _$ComentariosModelToJson(ComentariosModel instance) =>
    <String, dynamic>{
      'idcomentarios': instance.idcomentarios,
      'texto': instance.texto,
      'idusuario': instance.idusuario,
      'fecha': instance.fecha,
      'fullname': instance.fullname,
    };
