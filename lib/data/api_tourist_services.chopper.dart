// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_tourist_services.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$APITouristServices extends APITouristServices {
  _$APITouristServices([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = APITouristServices;

  @override
  Future<Response<UsuariosModel>> loginApp(RequestLogin login) {
    final $url = '/auth/login';
    final $headers = {'Content-Type': 'application/json'};
    final $body = login;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<UsuariosModel, UsuariosModel>($request);
  }

  @override
  Future<Response<UsuariosModel>> InfoUser(String token) {
    final $url = '/auth/info';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<UsuariosModel, UsuariosModel>($request);
  }

  @override
  Future<Response<ResponseTourist>> recuperarContrasena(String email) {
    final $url = '/auth/recuperar/$email';
    final $headers = {'Content-Type': 'application/json'};
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<ResponseTourist, ResponseTourist>($request);
  }

  @override
  Future<Response<List<UsuariosModel>>> listUsers(String token) {
    final $url = '/usuarios/list';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<List<UsuariosModel>, UsuariosModel>($request);
  }

  @override
  Future<Response<ResponseTourist>> addUsers(
      UsuariosModel usuario, String token) {
    final $url = '/usuarios/add';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $body = usuario;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<ResponseTourist, ResponseTourist>($request);
  }

  @override
  Future<Response<ResponseTourist>> updateUsers(
      UsuariosModel usuario, String idusuario, String token) {
    final $url = '/usuarios/update/$idusuario';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $body = usuario;
    final $request =
        Request('PATCH', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<ResponseTourist, ResponseTourist>($request);
  }

  @override
  Future<Response<ResponseTourist>> deleteUsers(
      String idusuario, String token) {
    final $url = '/usuarios/delete/$idusuario';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $request = Request('DELETE', $url, client.baseUrl, headers: $headers);
    return client.send<ResponseTourist, ResponseTourist>($request);
  }

  @override
  Future<Response<List<ComentariosModel>>> listComentarios(String token) {
    final $url = '/comentarios/list';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<List<ComentariosModel>, ComentariosModel>($request);
  }

  @override
  Future<Response<ResponseTourist>> addComentarios(
      ComentariosModel comentario, String token) {
    final $url = '/comentarios/add';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $body = comentario;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<ResponseTourist, ResponseTourist>($request);
  }

  @override
  Future<Response<List<SitiosModel>>> listSitios(String token) {
    final $url = '/sitios/list';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<List<SitiosModel>, SitiosModel>($request);
  }

  @override
  Future<Response<ResponseTourist>> addSitios(
      SitiosModel sitios, String token) {
    final $url = '/sitios/add';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $body = sitios;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<ResponseTourist, ResponseTourist>($request);
  }

  @override
  Future<Response<ResponseTourist>> calificar(
      String idsitio, String idimagen, int calificacion, String token) {
    final $url = '/sitios/calificar/$idsitio/$idimagen/$calificacion';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $request = Request('POST', $url, client.baseUrl, headers: $headers);
    return client.send<ResponseTourist, ResponseTourist>($request);
  }

  @override
  Future<Response<ResponseTourist>> savePosition(
      String idimagen, ImagenesModel imagen, String token) {
    final $url = '/sitios/imagen_position/$idimagen';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $body = imagen;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<ResponseTourist, ResponseTourist>($request);
  }

  @override
  Future<Response<ResponseTourist>> deleteSitios(String idsitio, String token) {
    final $url = '/sitios/delete/$idsitio';
    final $headers = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final $request = Request('DELETE', $url, client.baseUrl, headers: $headers);
    return client.send<ResponseTourist, ResponseTourist>($request);
  }
}
