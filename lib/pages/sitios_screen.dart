import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/error_model.dart';
import 'package:tourist_flutter/data/models/sitios_model.dart';
import 'package:tourist_flutter/helpers/loading.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';
import 'package:tourist_flutter/pages/sitios_add_screen.dart';
import 'package:tourist_flutter/pages/sitios_details.dart';

class SitiosScreen extends StatefulWidget {
  String token, rol;

  SitiosScreen({@required this.token, @required this.rol});

  @override
  _SitiosScreenState createState() {
    return _SitiosScreenState();
  }
}

class _SitiosScreenState extends State<SitiosScreen> {
  bool _isLoading = false, _buscar = false;
  String _search = '';
  List<SitiosModel> _listSitios = new List();
  var logger = new Logger();
  TextEditingController _tecBuscar = new TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarSitios();
  }

  Future<void> cargarSitios() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await Provider.of<APITouristServices>(context, listen: false).listSitios(widget.token);
      setState(() {
        _isLoading = false;
      });
      logger.i(response.statusCode);

      switch (response.statusCode) {
        case 200:
          setState(() {
            _listSitios = response.body;
          });
          break;
      }
    } catch (e) {
      showErrorToast(context, 'Sitios turisticos', 'Lo sentimos ha ocurrido un error al realizar está solicitud');
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
        backgroundColor: Color.fromRGBO(12, 232, 12, 1),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.home,
            size: screenSize(22.0, context),
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Sitios turísticos'.toUpperCase(),
          style: TextStyle(fontSize: screenSize(18.0, context), color: Colors.white),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _buscar = true;
              });
            },
          ),
          widget.rol == 'admin'
              ? IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.white,
                  ),
                  onPressed: () => agregarSitio(),
                )
              : SizedBox(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.asset('assets/images/fondo_sitios.jpg').image,
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSize(10.0, context), vertical: screenSize(15.0, context)),
                  child: Column(
                    children: [
                      _buscar
                          ? Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextFormField(
                                controller: _tecBuscar,
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  setState(() {
                                    _search = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Buscar ...',
                                  hintStyle: TextStyle(
                                    color: Colors.black45,
                                  ),
                                  errorStyle: TextStyle(),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        _tecBuscar.text = '';
                                        _search = '';
                                        _buscar = false;
                                      });
                                    },
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenSize(14.0, context),
                                ),
                              ),
                            )
                          : SizedBox(),
                      Container(
                        height: size.height * 0.85,
                        child: ListView.builder(
                          itemCount: listSitios.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => detallesSitios(_listSitios[index]),
                              child: GestureDetector(
                                onLongPress: () {
                                  setState(() {
                                    listSitios[index].opciones = true;
                                  });
                                },
                                child: Card(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(child: Text(listSitios[index].nombre.toUpperCase())),
                                        ),
                                        listSitios[index].opciones == true
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(horizontal: screenSize(20.0, context)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () => deleteSitios(listSitios[index].idsitio),
                                                      child: Icon(Icons.delete_outline),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    )),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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

  List<SitiosModel> get listSitios {
    List<SitiosModel> search = new List();

    if (_search != '') {
      _listSitios.forEach((element) {
        if (element.nombre.toLowerCase().contains(_search.toLowerCase())) {
          search.add(element);
        }
      });
      return search;
    }

    return _listSitios;
  }

  Future<void> agregarSitio() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SitiosAddScreen(token: widget.token);
    }));

    cargarSitios();
  }

  Future<void> detallesSitios(SitiosModel sitio) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SitiosDetails(sitios: sitio, token: widget.token, rol: widget.rol);
    }));

    cargarSitios();
  }

  Future<void> deleteSitios(String idsitio) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await Provider.of<APITouristServices>(context, listen: false).deleteSitios(idsitio, widget.token);
      setState(() {
        _isLoading = false;
      });
      logger.i(response.statusCode);

      switch (response.statusCode) {
        case 200:
          cargarSitios();
          break;

        case 400:
          showErrorToast(context, 'Registro de usuarios', ErrorModel.fromJson(json.decode(response.error)).error);
          break;

        default:
          showErrorToast(context, 'Registro de usuarios', 'Lo sentimos ha ocurrido un error al realizar está solicitud.');
          break;
      }
    } catch (e) {
      showErrorToast(context, 'Tourist', 'Lo sentimos ha ocurrido un error al realizar está solicitud');
    }
  }
}
