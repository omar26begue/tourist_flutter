import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/error_model.dart';
import 'package:tourist_flutter/data/models/usuarios_model.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';
import 'package:tourist_flutter/pages/usuarios_add_screen.dart';
import 'package:tourist_flutter/widgets/card_usuarios.dart';

class UsuariosScreen extends StatefulWidget {
  String token;

  UsuariosScreen({@required this.token});

  @override
  _UsuariosScreenState createState() {
    return _UsuariosScreenState();
  }
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  bool _isLoading = false;
  var logger = new Logger();
  List<UsuariosModel> _listUsuarios = new List();

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  cargarUsuarios() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await Provider.of<APITouristServices>(context, listen: false).listUsers(widget.token);
      setState(() {
        _isLoading = false;
      });
      logger.i(response.statusCode);

      switch (response.statusCode) {
        case 200:
          setState(() {
            _listUsuarios = response.body;
          });
          break;

        case 400:
          showErrorToast(context, 'Registro de usuarios', ErrorModel.fromJson(json.decode(response.error)).error);
          break;

        default:
          showErrorToast(context, 'Gestión de usuarios', 'Lo sentimos ha ocurrido un error al realizar está solicitud.');
          break;
      }
    } catch (e) {
      showErrorToast(context, 'Usuarios', 'Lo sentimos no se puedo completar esta solicitud');
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
            gradient:
                LinearGradient(colors: [Colors.green, Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter, tileMode: TileMode.clamp),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: screenSize(10.0, context)),
                  Container(
                    width: size.width,
                    child: Text(
                      'Gestión de usuarios',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize(16.0, context),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize(10.0, context)),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenSize(10.0, context)),
                      child: ListView.builder(
                        itemCount: _listUsuarios.length,
                        itemBuilder: (context, index) {
                          return CardUsuariosWidget(
                            usuario: _listUsuarios[index],
                            token: widget.token,
                            funcion: () => cargarUsuarios(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: screenSize(20.0, context),
                right: screenSize(10.0, context),
                child: Container(
                  padding: EdgeInsets.all(screenSize(2.0, context)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Colors.white,
                  ),
                  child: GestureDetector(
                    onTap: () => agregarUsuario(),
                    child: Icon(
                      Icons.add_circle,
                      size: screenSize(35.0, context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> agregarUsuario() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UsuariosAddScreen(token: widget.token, operation: 'add');
    }));

    cargarUsuarios();
  }
}
