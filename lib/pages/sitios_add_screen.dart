import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/error_model.dart';
import 'package:tourist_flutter/data/models/sitios_model.dart';
import 'package:tourist_flutter/helpers/loading.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';

class SitiosAddScreen extends StatefulWidget {
  String token, operation;

  SitiosAddScreen({@required this.token});

  @override
  _SitiosAddScreenState createState() {
    return _SitiosAddScreenState();
  }
}

class _SitiosAddScreenState extends State<SitiosAddScreen> {
  bool _isLoading = false;
  final _formSitios = GlobalKey<FormState>();
  TextEditingController _tecNombre = new TextEditingController();
  TextEditingController _tecUbicacion = new TextEditingController();
  TextEditingController _tecDistancia = new TextEditingController();
  TextEditingController _tecTiempo = new TextEditingController();
  TextEditingController _tecPoblacion = new TextEditingController();
  TextEditingController _tecDescripcion = new TextEditingController();
  DateTime horaInicio, horaFin;
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(12, 232, 12, 1),
        elevation: 0.0,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: screenSize(22.0, context),
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        title: Text(
          'Agregar sitios turísticos'.toUpperCase(),
          style: TextStyle(fontSize: screenSize(14.0, context), color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              size: screenSize(22.0, context),
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formSitios,
            child: Container(
              width: size.width,
              //height: size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.asset('assets/images/fondo_sitios.jpg').image,
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Scrollable(
                    viewportBuilder: (context, aaa) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenSize(10.0, context), vertical: screenSize(15.0, context)),
                        child: Column(
                          children: [
                            widgetTextField(_tecNombre, 'Nombre del sitio', TextInputType.text),
                            widgetTextField(_tecUbicacion, 'Ubicación', TextInputType.text),
                            widgetTextField(_tecDistancia, 'Distancia', TextInputType.number),
                            widgetTextField(_tecTiempo, 'Tiempo de camino', TextInputType.number),
                            widgetTextField(_tecPoblacion, 'Población', TextInputType.number),
                            Card(
                              elevation: screenSize(5.0, context),
                              color: Colors.white70,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenSize(10.0, context)),
                                child: TextFormField(
                                  controller: _tecDescripcion,
                                  validator: (value) {
                                    if (value.isEmpty) return "Campo requerido";
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Descripción',
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
                            ),
                            Card(
                              elevation: screenSize(5.0, context),
                              color: Colors.white70,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Apertura'),
                                  TimePickerSpinner(
                                    is24HourMode: true,
                                    isForce2Digits: true,
                                    isShowSeconds: false,
                                    itemHeight: 50.0,
                                    minutesInterval: 30,
                                    normalTextStyle: TextStyle(color: Colors.black, fontSize: screenSize(12.0, context)),
                                    highlightedTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenSize(24.0, context),
                                    ),
                                    onTimeChange: (DateTime time) {
                                      setState(() {
                                        horaInicio = time;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              elevation: screenSize(5.0, context),
                              color: Colors.white70,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Cierre'),
                                  TimePickerSpinner(
                                    is24HourMode: true,
                                    isForce2Digits: true,
                                    isShowSeconds: false,
                                    itemHeight: 50.0,
                                    minutesInterval: 30,
                                    normalTextStyle: TextStyle(color: Colors.black, fontSize: screenSize(12.0, context)),
                                    highlightedTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: screenSize(24.0, context),
                                    ),
                                    onTimeChange: (DateTime time) {
                                      setState(() {
                                        horaFin = time;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenSize(20.0, context)),
                            _btnAgregar(),
                          ],
                        ),
                      );
                    },
                  ),
                  ShowLoadingTourist(loading: _isLoading),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetTextField(TextEditingController controller, String hintText, TextInputType tipo) {
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

  Widget _btnAgregar() {
    return InkWell(
      onTap: () => widget.operation != 'update' ? agregarSitioToristico() : modificarSitioToristico(),
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

  Future<void> agregarSitioToristico() async {
    try {
      FocusScope.of(context).requestFocus(new FocusNode());
      final formSitios = _formSitios.currentState;

      if (formSitios.validate()) {
        setState(() {
          _isLoading = true;
        });
        SitiosModel sitios = new SitiosModel(
          nombre: _tecNombre.text,
          ubicacion: _tecUbicacion.text,
          distancia: double.parse(_tecDistancia.text),
          tiempo: int.parse(_tecTiempo.text),
          poblacion: int.parse(_tecPoblacion.text),
          descripcion: _tecDescripcion.text,
          hora_apertura: horaInicio.hour.toString() + ':' + horaInicio.minute.toString(),
          hora_cierre: horaFin.hour.toString() + ':' + horaFin.minute.toString(),
        );
        print(sitios.toJson());
        final response = await Provider.of<APITouristServices>(context, listen: false).addSitios(sitios, widget.token);
        setState(() {
          _isLoading = false;
        });
        logger.i(response.statusCode);

        switch (response.statusCode) {
          case 200:
            showSuccessToast(context, 'Sitio turisticos', response.body.message);
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
      showErrorToast(context, 'Sitio turistico', 'Lo sentimos no se puedo completar esta solicitud');
    }
  }

  void modificarSitioToristico() {}
}
