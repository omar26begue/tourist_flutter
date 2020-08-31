import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/sitios_model.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';

class MapsScreen extends StatefulWidget {
  String token;

  MapsScreen({@required this.token});

  @override
  _MapsScreenState createState() {
    return _MapsScreenState();
  }
}

class _MapsScreenState extends State<MapsScreen> {
  final Set<Marker> _markers = Set();
  Completer<GoogleMapController> _controller = Completer();
  List<SitiosModel> _listSitios;

  @override
  void initState() {
    super.initState();
    cargarSitios();
  }

  Future<void> cargarSitios() async {
    try {
      final response = await Provider.of<APITouristServices>(context, listen: false).listSitios(widget.token);

      switch (response.statusCode) {
        case 200:
          setState(() {
            _listSitios = response.body;
          });

          for (int index = 0; index < response.body.length; index++) {
            for (int i = 0; i < response.body[index].imagenes.length; i++) {
              _markers.add(Marker(
                markerId: MarkerId(response.body[index].imagenes[i].idimagenes),
                position: LatLng(response.body[index].imagenes[i].lat, response.body[index].imagenes[i].lon),
                //icon: pinLocationIcon,
                icon: BitmapDescriptor.defaultMarker,
              ));
            }
          }
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
      body: Container(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                mapToolbarEnabled: false,
                rotateGesturesEnabled: false,
                myLocationEnabled: false,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    _controller.complete(controller);
                  });

                  //centrarMapa();
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(-7.94, -76.82),
                  zoom: 7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void centrarMapa() async {
    GoogleMapController mapController = await _controller.future;
    await mapController.getVisibleRegion();

    var left = min(_markers.elementAt(0).position.latitude, _markers.elementAt(1).position.latitude);
    var rigth = max(_markers.elementAt(0).position.latitude, _markers.elementAt(1).position.latitude);
    var top = max(_markers.elementAt(0).position.longitude, _markers.elementAt(1).position.longitude);
    var botton = min(_markers.elementAt(0).position.longitude, _markers.elementAt(1).position.longitude);

    var bounds = LatLngBounds(
      southwest: LatLng(left, botton),
      northeast: LatLng(rigth, top),
    );
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    mapController.animateCamera(cameraUpdate);
  }
}
