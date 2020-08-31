import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/comentarios_model.dart';
import 'package:tourist_flutter/data/models/error_model.dart';
import 'package:tourist_flutter/helpers/loading.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';
import 'package:tourist_flutter/widgets/card_comentarios.dart';

class ComentariosScreen extends StatefulWidget {
  String token;

  ComentariosScreen({@required this.token});

  @override
  _ComentariosScreenState createState() {
    return _ComentariosScreenState();
  }
}

class _ComentariosScreenState extends State<ComentariosScreen> {
  bool _isLoading = false, comentario = false;
  List<ComentariosModel> _listComentarios = new List();
  TextEditingController _tecComentario = new TextEditingController();
  var logger = new Logger();

  @override
  void initState() {
    super.initState();
    cargarComentarios();
  }

  cargarComentarios() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await Provider.of<APITouristServices>(context, listen: false).listComentarios(widget.token);
      setState(() {
        _isLoading = false;
      });
      logger.i(response.statusCode);

      switch (response.statusCode) {
        case 200:
          setState(() {
            _listComentarios = response.body;
          });
          break;

        case 400:
          showErrorToast(context, 'Comentarios', ErrorModel.fromJson(json.decode(response.error)).error);
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/fondo_home.png').image,
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: size.width,
                      color: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: screenSize(5.0, context)),
                      child: Text(
                        'Comentarios',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize(16.0, context),
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize(20.0, context)),
                    comentario
                        ? Expanded(
                            flex: 3,
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _tecComentario,
                                    maxLines: 6,
                                  ),
                                  Container(
                                    color: Colors.grey,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: screenSize(5.0, context)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                comentario = false;
                                              });
                                            },
                                            child: Icon(Icons.cancel),
                                          ),
                                          GestureDetector(
                                            onTap: () => agregarComentario(),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    Expanded(
                      flex: 7,
                      child: ListView.builder(
                        itemCount: _listComentarios.length,
                        itemBuilder: (context, index) {
                          return CardComentariosWidget(comentarios: _listComentarios[index]);
                        },
                      ),
                    ),
                  ],
                ),
                !comentario
                    ? Positioned(
                        bottom: screenSize(40.0, context),
                        right: screenSize(10.0, context),
                        child: Container(
                          padding: EdgeInsets.all(screenSize(2.0, context)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Colors.white,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                comentario = true;
                              });
                            },
                            child: Icon(
                              Icons.add_circle,
                              size: screenSize(35.0, context),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                ShowLoadingTourist(loading: _isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> agregarComentario() async {
    try {
      setState(() {
        _isLoading = true;
      });
      ComentariosModel comentarioM = new ComentariosModel(texto: _tecComentario.text);
      final response = await Provider.of<APITouristServices>(context, listen: false).addComentarios(comentarioM, widget.token);
      setState(() {
        _isLoading = false;
      });
      logger.i(response.statusCode);

      switch (response.statusCode) {
        case 200:
          cargarComentarios();
          showSuccessToast(context, 'Comentario', response.body.message);
          setState(() {
            comentario = false;
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
      showErrorToast(context, 'Comentarios', 'Lo sentimos no se puedo completar esta solicitud');
    }
  }
}
