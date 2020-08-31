import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/error_model.dart';
import 'package:tourist_flutter/data/models/usuarios_model.dart';
import 'package:tourist_flutter/helpers/constants.dart';
import 'package:tourist_flutter/helpers/dialog.dart';
import 'package:tourist_flutter/helpers/session_manager.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';
import 'package:tourist_flutter/pages/comentarios_screen.dart';
import 'package:tourist_flutter/pages/maps_screen.dart';
import 'package:tourist_flutter/pages/play_screen.dart';
import 'package:tourist_flutter/pages/sitios_screen.dart';
import 'package:tourist_flutter/pages/usuarios_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  String _token;
  UsuariosModel _usuarioInfo;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  cargarDatos() async {
    String token = await SessionManagerTourist().getToken();
    setState(() {
      _token = token;
    });

    cargarInformacionUsuario();
  }

  cargarInformacionUsuario() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await Provider.of<APITouristServices>(context, listen: false).InfoUser(_token);
      setState(() {
        _isLoading = false;
      });
      print(_token);
      logger.i(response.statusCode);

      switch (response.statusCode) {
        case 200:
          setState(() {
            _usuarioInfo = response.body;
          });
          break;

        case 400:
          showErrorToast(context, 'Registro de usuarios', ErrorModel.fromJson(json.decode(response.error)).error);
          break;

        case 401:
          await SessionManagerTourist().clearPrefTourist();
          Navigator.of(context).pushReplacementNamed(pageSplash);
          break;

        default:
          showErrorToast(context, 'Registro de usuarios', 'Lo sentimos ha ocurrido un error al realizar está solicitud.');
          break;
      }
    } catch (e) {
      showErrorToast(context, 'Tourist', 'Lo sentimos ha ocurrido un error al realizar está solicitud');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset('assets/images/fondo_home.png').image,
              fit: BoxFit.fill,
            ),
          ),
          child: _usuarioInfo != null
              ? Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: screenSize(5.0, context)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: screenSize(25.0, context),
                                backgroundImage: Image.network(GlobalConfiguration().getBool('app_prod')
                                        ? GlobalConfiguration().getString('url_api_prod') + "/storage/" + _usuarioInfo.photo
                                        : GlobalConfiguration().getString('url_api_dev') + "/storage/" + _usuarioInfo.photo)
                                    .image,
                              ),
                              Text(
                                _usuarioInfo.nombres + ' ' + _usuarioInfo.apellido1,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenSize(12.0, context),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => salirAplicacion(),
                                child: Image.asset(
                                  'assets/images/icon_exit_app.png',
                                  width: screenSize(40.0, context),
                                  height: screenSize(40.0, context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    _usuarioInfo.rol == 'admin'
                        ? Positioned(
                            top: screenSize(150.0, context),
                            left: screenSize(15.0, context),
                            child: GestureDetector(
                              onTap: () => gestionarUsuarios(),
                              child: Container(
                                padding: EdgeInsets.all(screenSize(7.0, context)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                  color: Colors.blueAccent,
                                ),
                                child: Icon(
                                  Icons.supervised_user_circle,
                                  color: Colors.white,
                                  size: screenSize(30.0, context),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Positioned(
                      top: screenSize(150.0, context),
                      right: screenSize(15.0, context),
                      child: GestureDetector(
                        onTap: () => gestionarComentarios(),
                        child: Container(
                          padding: EdgeInsets.all(screenSize(7.0, context)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Colors.blueAccent,
                          ),
                          child: Icon(
                            Icons.message,
                            color: Colors.white,
                            size: screenSize(30.0, context),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenSize(200.0, context),
                      right: screenSize(15.0, context),
                      child: GestureDetector(
                        onTap: () {
                          
                        },
                        child: Image.asset(
                          'assets/images/facebook.png',
                          width: screenSize(45.0, context),
                          height: screenSize(45.0, context),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: screenSize(80.0, context),
                      child: Container(
                        width: size.width,
                        child: GestureDetector(
                          onTap: () => mostrarPlay(),
                          child: Image.asset(
                            'assets/images/icon_play.png',
                            width: screenSize(60.0, context),
                            height: screenSize(60.0, context),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: screenSize(20.0, context),
                      left: screenSize(20.0, context),
                      child: GestureDetector(
                        onTap: () => gestionarSitiosTuristicos(),
                        child: Image.asset(
                          'assets/images/icon_tourist.png',
                          width: screenSize(60.0, context),
                          height: screenSize(60.0, context),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: screenSize(20.0, context),
                      right: screenSize(20.0, context),
                      child: GestureDetector(
                        onTap: () => mostrarSitios(),
                        child: Image.asset(
                          'assets/images/icon_maps.png',
                          width: screenSize(60.0, context),
                          height: screenSize(60.0, context),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ),
      ),
    );
  }

  void salirAplicacion() {
    DialogTourist.showCupertinoDialogSiNo(
      context: context,
      title: 'Confirmación',
      texto: 'Desea salir de la aplicación. Tourist ?',
      btnAceptar: () {
        SessionManagerTourist().clearPrefTourist();
        Navigator.of(context).pushReplacementNamed(pageSplash);
      },
    );
  }

  void gestionarUsuarios() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UsuariosScreen(token: _token);
    }));
  }

  void gestionarComentarios() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ComentariosScreen(token: _token);
    }));
  }

  void gestionarSitiosTuristicos() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SitiosScreen(token: _token, rol: _usuarioInfo.rol);
    }));
  }

  void mostrarSitios() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MapsScreen(token: _token);
    }));
  }

  void mostrarPlay() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PlayScreen(token: _token);
    }));
  }
}
