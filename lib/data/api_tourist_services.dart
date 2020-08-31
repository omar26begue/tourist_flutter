import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:tourist_flutter/data/models/comentarios_model.dart';
import 'package:tourist_flutter/data/models/error_model.dart';
import 'package:tourist_flutter/data/models/imagenes_model.dart';
import 'package:tourist_flutter/data/models/sitios_model.dart';
import 'package:tourist_flutter/data/models/usuarios_model.dart';
import 'package:tourist_flutter/data/request/request_login.dart';
import 'package:tourist_flutter/data/responses/response_tourist.dart';

part 'api_tourist_services.chopper.dart';

@ChopperApi(baseUrl: '')
abstract class APITouristServices extends ChopperService {
  /// registro de usuarios
  @Post(headers: {'Content-Type': 'application/json'}, path: "/auth/login")
  Future<Response<UsuariosModel>> loginApp(@Body() RequestLogin login);

  /// informacion del suaurio autenticado
  @Get(headers: {'Content-Type': 'application/json'}, path: "/auth/info")
  Future<Response<UsuariosModel>> InfoUser(@Header("Authorization") String token);

  /// recuperar contraseña
  @Get(headers: {'Content-Type': 'application/json'}, path: "/auth/recuperar/{email}")
  Future<Response<ResponseTourist>> recuperarContrasena(@Path("email") String email);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /// listar los usuario
  @Get(headers: {'Content-Type': 'application/json'}, path: "/usuarios/list")
  Future<Response<List<UsuariosModel>>> listUsers(@Header("Authorization") String token);

  /// agregar usuario
  @Post(headers: {'Content-Type': 'application/json'}, path: "/usuarios/add")
  Future<Response<ResponseTourist>> addUsers(@Body() UsuariosModel usuario, @Header("Authorization") String token);

  /// modificar usuario
  @Patch(headers: {'Content-Type': 'application/json'}, path: "/usuarios/update/{idusuario}")
  Future<Response<ResponseTourist>> updateUsers(@Body() UsuariosModel usuario, @Path("idusuario") String idusuario, @Header("Authorization") String token);

  /// eliminar usuario
  @Delete(headers: {'Content-Type': 'application/json'}, path: "/usuarios/delete/{idusuario}")
  Future<Response<ResponseTourist>> deleteUsers(@Path("idusuario") String idusuario, @Header("Authorization") String token);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /// listar comentarios
  @Get(headers: {'Content-Type': 'application/json'}, path: "/comentarios/list")
  Future<Response<List<ComentariosModel>>> listComentarios(@Header("Authorization") String token);

  /// agregar comentarios
  @Post(headers: {'Content-Type': 'application/json'}, path: "/comentarios/add")
  Future<Response<ResponseTourist>> addComentarios(@Body() ComentariosModel comentario, @Header("Authorization") String token);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /// listar sitios turisticos
  @Get(headers: {'Content-Type': 'application/json'}, path: "/sitios/list")
  Future<Response<List<SitiosModel>>> listSitios(@Header("Authorization") String token);

  /// agregar sitios turisticos
  @Post(headers: {'Content-Type': 'application/json'}, path: "/sitios/add")
  Future<Response<ResponseTourist>> addSitios(@Body() SitiosModel sitios, @Header("Authorization") String token);

  /// agregar sitios turisticos
  @Post(headers: {'Content-Type': 'application/json'}, path: "/sitios/calificar/{idsitio}/{idimagen}/{calificacion}")
  Future<Response<ResponseTourist>> calificar(
      @Path("idsitio") String idsitio, @Path("idimagen") String idimagen, @Path("calificacion") int calificacion, @Header("Authorization") String token);

  @Post(headers: {'Content-Type': 'application/json'}, path: "/sitios/imagen_position/{idimagen}")
  Future<Response<ResponseTourist>> savePosition(@Path("idimagen") String idimagen, @Body() ImagenesModel imagen, @Header("Authorization") String token);

  /// eliminar sitio
  @Delete(headers: {'Content-Type': 'application/json'}, path: "/sitios/delete/{idsitio}")
  Future<Response<ResponseTourist>> deleteSitios(@Path("idsitio") String idsitio, @Header("Authorization") String token);

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  static APITouristServices create() {
    final client = ChopperClient(
        baseUrl:
            GlobalConfiguration().getBool('app_prod') ? GlobalConfiguration().getString('url_api_prod') : GlobalConfiguration().getString('url_api_dev'),
        services: [_$APITouristServices()],
        converter: JsonToTypeConverter({
          ResponseTourist: (jsonData) => ResponseTourist.fromJson(jsonData),
          ErrorModel: (jsonData) => ErrorModel.fromJson(jsonData),
          UsuariosModel: (jsonData) => UsuariosModel.fromJson(jsonData),
          ComentariosModel: (jsonData) => ComentariosModel.fromJson(jsonData),
          SitiosModel: (jsonData) => SitiosModel.fromJson(jsonData),
          ImagenesModel: (jsonData) => ImagenesModel.fromJson(jsonData),
        }));

    return _$APITouristServices(client);
  }
}

class JsonToTypeConverter extends JsonConverter {
  final Map<Type, Function> typeToJsonFactoryMap;

  JsonToTypeConverter(this.typeToJsonFactoryMap);

  T fromJsonData<T, InnerType>(String jsonData, Function jsonParse) {
    var jsonMap = json.decode(jsonData);

    if (jsonMap is List) {
      return jsonMap.map((item) => jsonParse(item as Map<String, dynamic>) as InnerType).toList() as T;
    }

    return jsonParse(jsonMap);
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    // ignore: deprecated_member_use
    return response.replace(
      body: fromJsonData<BodyType, InnerType>(response.body, typeToJsonFactoryMap[InnerType]),
    );
  }
}
