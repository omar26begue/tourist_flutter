import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/error_model.dart';
import 'package:tourist_flutter/data/models/usuarios_model.dart';
import 'package:tourist_flutter/helpers/dialog.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';
import 'package:tourist_flutter/pages/usuarios_add_screen.dart';

class CardUsuariosWidget extends StatefulWidget {
  String token;
  UsuariosModel usuario;
  Function funcion;

  CardUsuariosWidget({@required this.token, @required this.usuario, @required this.funcion});

  @override
  _CardUsuariosWidgetState createState() {
    return _CardUsuariosWidgetState();
  }
}

class _CardUsuariosWidgetState extends State<CardUsuariosWidget> {
  bool isLoading = false;
  var logger = new Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == false
        ? Card(
            child: ListTile(
              title: Text(widget.usuario.nombres + ' ' + widget.usuario.apellido1 + ' ' + widget.usuario.apellido2),
              leading: Image.network(GlobalConfiguration().getBool('app_prod')
                  ? GlobalConfiguration().getString('url_api_prod') + "/storage/" + widget.usuario.photo
                  : GlobalConfiguration().getString('url_api_dev') + "/storage/" + widget.usuario.photo),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return UsuariosAddScreen(
                          token: widget.token,
                          operation: 'update',
                          usuario: widget.usuario,
                        );
                      }));

                      widget.funcion();
                    },
                    child: Icon(Icons.update),
                  ),
                  GestureDetector(
                      onTap: () {
                        DialogTourist.showCupertinoDialogSiNo(
                            context: context,
                            title: 'Eliminar usuario',
                            texto: 'Está seguro que desea eliminar el usuario ' +
                                widget.usuario.nombres +
                                ' ' +
                                widget.usuario.apellido1 +
                                ' ' +
                                widget.usuario.apellido2 +
                                ' del sistema?',
                            btnAceptar: () => eliminarUsuario());
                      },
                      child: Icon(Icons.delete_outline)),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            )),
          );
  }

  Future<void> eliminarUsuario() async {
    try {
      Navigator.of(context).pop();
      setState(() {
        isLoading = true;
      });
      final response = await Provider.of<APITouristServices>(context, listen: false).deleteUsers(widget.usuario.idusuario, widget.token);
      setState(() {
        isLoading = false;
      });
      logger.i(response.statusCode);

      switch (response.statusCode) {
        case 200:
          showSuccessToast(context, 'Usuario', response.body.message);
          widget.funcion();
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
}
