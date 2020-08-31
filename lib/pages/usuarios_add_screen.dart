import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/error_model.dart';
import 'package:tourist_flutter/data/models/usuarios_model.dart';
import 'package:tourist_flutter/helpers/loading.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';

class UsuariosAddScreen extends StatefulWidget {
  String token, operation;
  UsuariosModel usuario;

  UsuariosAddScreen({@required this.token, @required this.operation, this.usuario});

  @override
  _UsuariosAddScreenState createState() {
    return _UsuariosAddScreenState();
  }
}

class _UsuariosAddScreenState extends State<UsuariosAddScreen> {
  bool _isLoading = false;
  String _rolSelect;
  var logger = new Logger();
  final _formUsarios = GlobalKey<FormState>();
  TextEditingController _tecEmailUsuario = new TextEditingController();
  TextEditingController _tecNombreUsuario = new TextEditingController();
  TextEditingController _tecApellidos1Usuario = new TextEditingController();
  TextEditingController _tecApellidos2Usuario = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.operation == 'update') {
      setState(() {
        _tecEmailUsuario.text = widget.usuario.email;
        _rolSelect = widget.usuario.rol;
        _tecNombreUsuario.text = widget.usuario.nombres;
        _tecApellidos1Usuario.text = widget.usuario.apellido1;
        _tecApellidos2Usuario.text = widget.usuario.apellido2;
      });
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
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: screenSize(22.0, context),
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.operation != 'update' ? 'Agregar usuario' : 'Modificar usuario',
          style: TextStyle(fontSize: screenSize(16.0, context), color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.green, Colors.white], begin: Alignment.topCenter, end: Alignment.bottomCenter, tileMode: TileMode.clamp),
                  ),
                  child: Form(
                    key: _formUsarios,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenSize(10.0, context)),
                      child: Column(
                        children: [
                          widgetTextFieldUsuario(_tecEmailUsuario, 'Correo electrónico', TextInputType.emailAddress),
                          _widgetRol(),
                          widgetTextFieldUsuario(_tecNombreUsuario, 'Nombre del usuario', TextInputType.text),
                          widgetTextFieldUsuario(_tecApellidos1Usuario, 'Primer apellido', TextInputType.text),
                          widgetTextFieldUsuario(_tecApellidos2Usuario, 'Segundo apellido', TextInputType.text),
                          SizedBox(height: screenSize(30.0, context)),
                          _btnAgregar(),
                        ],
                      ),
                    ),
                  ),
                ),
                ShowLoadingTourist(loading: _isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetTextFieldUsuario(TextEditingController controller, String hintText, TextInputType tipo) {
    return Card(
      elevation: screenSize(5.0, context),
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenSize(10.0, context)),
        child: TextFormField(
          controller: controller,
          validator: (value) {
            if (value.isEmpty) return "Campo requerido";
            return null;
          },
          keyboardType: tipo,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.black45,
            ),
            errorStyle: TextStyle(),
          ),
          style: TextStyle(
            color: Colors.black,
            fontSize: screenSize(14.0, context),
          ),
        ),
      ),
    );
  }

  Widget _widgetRol() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        RadioListTile<String>(
          title: Text(
            "Administrador",
            style: TextStyle(color: Colors.white70),
          ),
          value: 'admin',
          groupValue: _rolSelect,
          activeColor: Colors.white,
          onChanged: (value) {
            setState(() {
              _rolSelect = value;
            });
          },
        ),
        RadioListTile<String>(
          title: Text("Tourist", style: TextStyle(color: Colors.white70)),
          value: 'tourist',
          groupValue: _rolSelect,
          activeColor: Colors.white,
          onChanged: (value) {
            setState(() {
              _rolSelect = value;
            });
          },
        ),
      ],
    );
  }

  Widget _btnAgregar() {
    return InkWell(
      onTap: () => widget.operation != 'update' ? agregarUsuario() : modificarUsuario(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: screenSize(13.0, context)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          color: Colors.green,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              widget.operation != 'update' ? Icons.add : Icons.update,
              color: Colors.white,
            ),
            SizedBox(width: screenSize(5.0, context)),
            Text(
              widget.operation != 'update' ? "Agregar" : 'Actualizar',
              style: TextStyle(
                fontSize: screenSize(18.0, context),
                letterSpacing: screenSize(1.5, context),
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> agregarUsuario() async {
    try {
      FocusScope.of(context).requestFocus(new FocusNode());
      final formUsuarios = _formUsarios.currentState;

      if (formUsuarios.validate()) {
        setState(() {
          _isLoading = true;
        });
        UsuariosModel usuario = new UsuariosModel(
          rol: _rolSelect,
          nombres: _tecNombreUsuario.text,
          apellido1: _tecApellidos1Usuario.text,
          apellido2: _tecApellidos2Usuario.text,
          email: _tecEmailUsuario.text,
        );
        final response = await Provider.of<APITouristServices>(context, listen: false).addUsers(usuario, widget.token);
        setState(() {
          _isLoading = false;
        });
        logger.i(response.statusCode);

        switch (response.statusCode) {
          case 200:
            Navigator.of(context).pop();
            showInfoToast(context, 'Usuarios', response.body.message);
            break;

          case 400:
            showErrorToast(context, 'Registro de usuarios', ErrorModel.fromJson(json.decode(response.error)).error);
            break;

          default:
            showErrorToast(context, 'Gestión de usuarios', 'Lo sentimos ha ocurrido un error al realizar está solicitud.');
            break;
        }
      }
    } catch (e) {
      showErrorToast(context, 'Usuarios', 'Lo sentimos no se puedo completar esta solicitud');
    }
  }

  modificarUsuario() async {
    try {
      FocusScope.of(context).requestFocus(new FocusNode());
      final formUsuarios = _formUsarios.currentState;

      if (formUsuarios.validate()) {
        setState(() {
          _isLoading = true;
        });
        UsuariosModel usuario = new UsuariosModel(
          rol: _rolSelect,
          nombres: _tecNombreUsuario.text,
          apellido1: _tecApellidos1Usuario.text,
          apellido2: _tecApellidos2Usuario.text,
          email: _tecEmailUsuario.text,
        );
        final response = await Provider.of<APITouristServices>(context, listen: false).updateUsers(usuario, widget.usuario.idusuario, widget.token);
        setState(() {
          _isLoading = false;
        });
        logger.i(response.statusCode);

        switch (response.statusCode) {
          case 200:
            Navigator.of(context).pop();
            showInfoToast(context, 'Usuarios', response.body.message);
            break;

          case 400:
            showErrorToast(context, 'Registro de usuarios', ErrorModel.fromJson(json.decode(response.error)).error);
            break;

          default:
            showErrorToast(context, 'Gestión de usuarios', 'Lo sentimos ha ocurrido un error al realizar está solicitud.');
            break;
        }
      }
    } catch (e) {
      showErrorToast(context, 'Usuarios', 'Lo sentimos no se puedo completar esta solicitud');
    }
  }
}
