// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuarios_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuariosModel _$UsuariosModelFromJson(Map<String, dynamic> json) {
  return UsuariosModel(
    idusuario: json['idusuario'] as String,
    rol: json['rol'] as String,
    nombres: json['nombres'] as String,
    apellido1: json['apellido1'] as String,
    apellido2: json['apellido2'] as String,
    email: json['email'] as String,
    photo: json['photo'] as String,
    access_token: json['access_token'] as String,
  );
}

Map<String, dynamic> _$UsuariosModelToJson(UsuariosModel instance) =>
    <String, dynamic>{
      'idusuario': instance.idusuario,
      'rol': instance.rol,
      'nombres': instance.nombres,
      'apellido1': instance.apellido1,
      'apellido2': instance.apellido2,
      'email': instance.email,
      'photo': instance.photo,
      'access_token': instance.access_token,
    };
