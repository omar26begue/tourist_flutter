import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/error_model.dart';
import 'package:tourist_flutter/data/request/request_login.dart';
import 'package:tourist_flutter/helpers/constants.dart';
import 'package:tourist_flutter/helpers/loading.dart';
import 'package:tourist_flutter/helpers/session_manager.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false, _showPassword = true;
  var logger = Logger();
  final _formLogin = GlobalKey<FormState>();
  FocusNode _focusEmail = new FocusNode(), _focusPassword = new FocusNode();
  TextEditingController _emailController = new TextEditingController(), _passwordController = new TextEditingController();

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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.asset('assets/images/fondo_login.jpg').image,
                  fit: BoxFit.fill,
                ),
              ),
              child: Form(
                key: _formLogin,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenSize(40.0, context)),
                          Image.asset('assets/images/icon_app.png'),
                          SizedBox(height: screenSize(40.0, context)),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Card(
                              color: Colors.white70,
                              elevation: screenSize(5.0, context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: screenSize(5.0, context), left: screenSize(5.0, context)),
                                    child: TextFormField(
                                      focusNode: _focusEmail,
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value.isEmpty) return "Campo requerido";
                                        return null;
                                      },
                                      onFieldSubmitted: (v) {
                                        _formLogin.currentState.validate();
                                        FocusScope.of(context).requestFocus(_focusPassword);
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Correo electrónico",
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Neue",
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenSize(14.0, context),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: screenSize(5.0, context), left: screenSize(5.0, context)),
                                    child: TextFormField(
                                      focusNode: _focusPassword,
                                      controller: _passwordController,
                                      validator: (value) {
                                        if (value.isEmpty) return "Campo requerido";
                                        if (value.length < 5) return "Contraseña demasiado corta";
                                        return null;
                                      },
                                      onFieldSubmitted: (v) {
                                        _formLogin.currentState.validate();
                                      },
                                      obscureText: _showPassword,
                                      keyboardType: TextInputType.text,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Contraseña",
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Neue",
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _showPassword = !_showPassword;
                                            });
                                          },
                                          child: Icon(
                                            _showPassword == false ? Icons.visibility : Icons.visibility_off,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenSize(14.0, context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize(40.0, context)),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: screenSize(20.0, context)),
                        child: GestureDetector(
                          onTap: () => loginUsuario(),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: EdgeInsets.symmetric(vertical: screenSize(13.0, context)),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(7)),
                              color: Colors.green,
                            ),
                            child: Text(
                              "Entrar",
                              style: TextStyle(
                                fontSize: screenSize(18.0, context),
                                fontFamily: "Quicksand Bold",
                                letterSpacing: screenSize(1.5, context),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize(50.0, context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenSize(25.0, context)),
                            child: GestureDetector(
                              onTap: () => olvideContrasena(),
                              child: Text(
                                'Olvide mi contraseña',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenSize(12.0, context)
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            ShowLoadingTourist(loading: _isLoading),
          ],
        ),
      ),
    );
  }

  Future<void> loginUsuario() async {
    try {
      FocusScope.of(context).requestFocus(new FocusNode());
      final formLogin = _formLogin.currentState;
      if (formLogin.validate()) {
        setState(() {
          _isLoading = true;
        });
        RequestLogin login = new RequestLogin(email: _emailController.text, password: _passwordController.text);
        final response = await Provider.of<APITouristServices>(context, listen: false).loginApp(login);
        setState(() {
          _isLoading = false;
        });
        logger.i(response.statusCode);

        switch (response.statusCode) {
          case 200:
            SessionManagerTourist().setLoginTourist(response.body);
            Navigator.of(context).pushReplacementNamed(pageHome);
            break;

          case 400:
            showErrorToast(context, 'Registro de usuarios', ErrorModel.fromJson(json.decode(response.error)).error);
            break;

          default:
            showErrorToast(context, 'Registro de usuarios', 'Lo sentimos ha ocurrido un error al realizar está solicitud.');
            break;
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _emailController.text = "";
      _passwordController.text = "";
      logger.e(e.toString());
      showErrorToast(context, 'Tourist', 'Lo sentimos ha ocurrido un error al realizar está solicitud.');
    }
  }

  Future<void> olvideContrasena() async {
    try {
      FocusScope.of(context).requestFocus(new FocusNode());

      if (_emailController.text.length == 0) {
        showErrorToast(context, 'Tourist', 'Lo sentimos ha ocurrido un error al realizar está solicitud.');
        return;
      }

      setState(() {
        _isLoading = true;
      });
      final response = await Provider.of<APITouristServices>(context, listen: false).recuperarContrasena(_emailController.text);
      setState(() {
        _isLoading = false;
      });
      logger.i(response.statusCode);

      switch (response.statusCode) {
        case 200:
          showSuccessToast(context, 'Tourist', response.body.message);
          break;

        case 400:
          showErrorToast(context, 'Tourist', ErrorModel.fromJson(json.decode(response.error)).error);
          break;

        default:
          showErrorToast(context, 'Tourist', 'Lo sentimos ha ocurrido un error al realizar está solicitud.');
          break;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showErrorToast(context, 'Tourist', 'Lo sentimos ha ocurrido un error al realizar está solicitud.');
    }
  }
}
