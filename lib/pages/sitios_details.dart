import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/error_model.dart';
import 'package:tourist_flutter/data/models/imagenes_model.dart';
import 'package:tourist_flutter/data/models/sitios_model.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';
import 'package:tourist_flutter/pages/maps_sitios_screen.dart';
import 'package:tourist_flutter/widgets/clipper_widget.dart';
import 'package:http/http.dart' as http;

class SitiosDetails extends StatefulWidget {
  String token, rol;
  SitiosModel sitios;

  SitiosDetails({@required this.sitios, @required this.token, @required this.rol});

  @override
  _SitiosDetailsState createState() {
    return _SitiosDetailsState();
  }
}

class _SitiosDetailsState extends State<SitiosDetails> {
  bool _isLoading = false;
  int _countImage = 0;
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
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  ClipPath(
                    clipper: CurveClipper(),
                    child: Container(
                      width: size.width,
                      height: size.height * 0.5,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: widget.sitios.imagenes.length == 0
                            ? Image.asset('assets/images/fondo_sitios.jpg').image
                            : Image.network(GlobalConfiguration().getBool('app_prod')
                                    ? GlobalConfiguration().getString('url_api_prod') + '/storage/' + widget.sitios.imagenes[_countImage].nombre
                                    : GlobalConfiguration().getString('url_api_dev') + '/storage/' + widget.sitios.imagenes[_countImage].nombre)
                                .image,
                        fit: BoxFit.fill,
                      )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          widget.sitios.nombre.toUpperCase(),
                                          style: TextStyle(fontSize: screenSize(14.0, context)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              top: screenSize(120.0, context),
                              child: GestureDetector(
                                onTap: () => atrasImgen(),
                                child: Container(
                                  padding: EdgeInsets.all(screenSize(3.0, context)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    color: Colors.white30,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.blue,
                                    size: screenSize(25.0, context),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: screenSize(120.0, context),
                              right: screenSize(0.0, context),
                              child: GestureDetector(
                                onTap: () => siguienteImagen(),
                                child: Container(
                                  padding: EdgeInsets.all(screenSize(3.0, context)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    color: Colors.white30,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.blue,
                                    size: screenSize(25.0, context),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: screenSize(10.0, context),
                              left: screenSize(10.0, context),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(screenSize(3.0, context)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.blue,
                                    size: screenSize(25.0, context),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: screenSize(10.0, context),
                              left: screenSize(60.0, context),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(screenSize(3.0, context)),
                                  child: Icon(
                                    Icons.home,
                                    color: Colors.blue,
                                    size: screenSize(25.0, context),
                                  ),
                                ),
                              ),
                            ),
                            widget.rol == 'admin'
                                ? Positioned(
                                    bottom: screenSize(40.0, context),
                                    right: screenSize(10.0, context),
                                    child: GestureDetector(
                                      onTap: () => agregarFotoGaleria(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(25)),
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.all(screenSize(3.0, context)),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.blue,
                                          size: screenSize(25.0, context),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            widget.rol == 'admin'
                                ? Positioned(
                                    bottom: screenSize(40.0, context),
                                    right: screenSize(50.0, context),
                                    child: GestureDetector(
                                      onTap: () => agregarFotoCamara(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(25)),
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.all(screenSize(3.0, context)),
                                        child: Icon(
                                          Icons.camera,
                                          color: Colors.blue,
                                          size: screenSize(25.0, context),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            /*Positioned(
                              bottom: screenSize(80.0, context),
                              right: screenSize(50.0, context),
                              child: GestureDetector(
                                onTap: () => compartirImagen(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.all(screenSize(3.0, context)),
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.blue,
                                    size: screenSize(25.0, context),
                                  ),
                                ),
                              ),
                            ),*/
                            widget.sitios.imagenes.length > 0
                                ? Positioned(
                                    bottom: screenSize(80.0, context),
                                    right: screenSize(10.0, context),
                                    child: GestureDetector(
                                      onTap: () => localizarImagen(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(25)),
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.all(screenSize(3.0, context)),
                                        child: Icon(
                                          Icons.gps_fixed,
                                          color: Colors.blue,
                                          size: screenSize(25.0, context),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenSize(10.0, context)),
                    child: Column(
                      children: [
                        widget.sitios.imagenes.length > 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => calificarImagen(1),
                                    child: Icon(
                                      widget.sitios.imagenes[_countImage].calificacion >= 1 ? Icons.star : Icons.star_border,
                                      size: screenSize(35.0, context),
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => calificarImagen(2),
                                    child: Icon(
                                      widget.sitios.imagenes[_countImage].calificacion >= 2 ? Icons.star : Icons.star_border,
                                      size: screenSize(35.0, context),
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => calificarImagen(3),
                                    child: Icon(
                                      widget.sitios.imagenes[_countImage].calificacion >= 3 ? Icons.star : Icons.star_border,
                                      size: screenSize(35.0, context),
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => calificarImagen(4),
                                    child: Icon(
                                      widget.sitios.imagenes[_countImage].calificacion >= 4 ? Icons.star : Icons.star_border,
                                      size: screenSize(35.0, context),
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => calificarImagen(5),
                                    child: Icon(
                                      widget.sitios.imagenes[_countImage].calificacion >= 5 ? Icons.star : Icons.star_border,
                                      size: screenSize(35.0, context),
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                        SizedBox(height: screenSize(20.0, context)),
                        Wrap(
                          children: [
                            Text(
                              widget.sitios.descripcion,
                              textAlign: TextAlign.justify,
                              maxLines: 7,
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize(10.0, context)),
                        Row(
                          children: [Text('Ubicación:'), SizedBox(width: screenSize(10.0, context)), Text(widget.sitios.ubicacion)],
                        ),
                        SizedBox(height: screenSize(10.0, context)),
                        Row(
                          children: [
                            Text('Distancia:'),
                            SizedBox(width: screenSize(10.0, context)),
                            Text(widget.sitios.distancia.toString() + ' Km (' + widget.sitios.tiempo.toString() + ' min)')
                          ],
                        ),
                        SizedBox(height: screenSize(10.0, context)),
                        Row(
                          children: [
                            Text('Población:'),
                            SizedBox(width: screenSize(10.0, context)),
                            Text(widget.sitios.poblacion.toString() + ' habitantes')
                          ],
                        ),
                        SizedBox(height: screenSize(10.0, context)),
                        Row(
                          children: [
                            Text('Horario de atención:'),
                            SizedBox(width: screenSize(10.0, context)),
                            Text(widget.sitios.hora_apertura.substring(0, 5) + ' - ' + widget.sitios.hora_cierre.substring(0, 5))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void atrasImgen() {
    if (_countImage > 0) {
      setState(() {
        _countImage = _countImage - 1;
      });
    }
  }

  void siguienteImagen() {
    if (_countImage < widget.sitios.imagenes.length - 1) {
      setState(() {
        _countImage = _countImage + 1;
      });
    }
  }

  Future<void> agregarFotoCamara() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final request = http.MultipartRequest(
          'POST',
          Uri.parse(GlobalConfiguration().getBool('app_prod')
              ? GlobalConfiguration().getString('url_api_prod') + '/sitios/uploadphoto/' + widget.sitios.idsitio
              : GlobalConfiguration().getString('url_api_dev') + '/sitios/uploadphoto/' + widget.sitios.idsitio));

      Map<String, String> requestHeaders = {'Authorization': widget.token};
      request.headers.addAll(requestHeaders);
      request.files.add(await http.MultipartFile.fromPath('image_sitios', image.path));

      var response = await request.send();
      setState(() {
        _isLoading = false;
      });

      logger.i(response.statusCode);

      switch (response.statusCode) {
        case 200:
          Navigator.of(context).pop();
          showSuccessToast(context, 'Imagen', 'Imagen subida al servidor satisfactoriamente');
          break;

        default:
          logger.i(response.toString());
          showErrorToast(context, 'Imagen', 'No se pudo subir la imagen al servidor');
          break;
      }
    }
  }

  Future<void> agregarFotoGaleria() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final request = http.MultipartRequest(
          'POST',
          Uri.parse(GlobalConfiguration().getBool('app_prod')
              ? GlobalConfiguration().getString('url_api_prod') + '/sitios/uploadphoto/' + widget.sitios.idsitio
              : GlobalConfiguration().getString('url_api_dev') + '/sitios/uploadphoto/' + widget.sitios.idsitio));

      Map<String, String> requestHeaders = {'Authorization': widget.token};
      request.headers.addAll(requestHeaders);
      request.files.add(await http.MultipartFile.fromPath('image_sitios', image.path));

      var response = await request.send();
      setState(() {
        _isLoading = false;
      });

      logger.i(response.statusCode);

      switch (response.statusCode) {
        case 200:
          Navigator.of(context).pop();
          showSuccessToast(context, 'Imagen', 'Imagen subida al servidor satisfactoriamente');
          break;

        default:
          logger.i(await response.stream.bytesToString());
          showErrorToast(context, 'Imagen', 'No se pudo subir la imagen al servidor');
          break;
      }
    }
  }

  Future<void> calificarImagen(int calificacion) async {
    final response = await Provider.of<APITouristServices>(context, listen: false)
        .calificar(widget.sitios.idsitio, widget.sitios.imagenes[_countImage].idimagenes, calificacion, widget.token);
    logger.i(response.statusCode);

    switch (response.statusCode) {
      case 200:
        showInfoToast(context, 'Calificación', response.body.message);
        setState(() {
          widget.sitios.imagenes[_countImage].calificacion = double.parse(response.body.data.toString()).ceil();
        });
        break;
    }
  }

  Future<void> localizarImagen() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MapsSitiosScreen(imagenes: widget.sitios.imagenes[_countImage], token: widget.token, rol: widget.rol);
    }));
  }

  void compartirImagen() {
    //Share.
  }
}
