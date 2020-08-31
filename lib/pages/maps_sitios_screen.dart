import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/imagenes_model.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';

class MapsSitiosScreen extends StatefulWidget {
  ImagenesModel imagenes;
  String token, rol;

  MapsSitiosScreen({@required this.imagenes, @required this.token, @required this.rol});

  @override
  _MapsSitiosScreenState createState() {
    return _MapsSitiosScreenState();
  }
}

class _MapsSitiosScreenState extends State<MapsSitiosScreen> {
  var logger = new Logger();
  final Set<Marker> _markers = Set();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _position;

  @override
  void initState() {
    super.initState();

    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(widget.imagenes.idimagenes),
          position: LatLng(widget.imagenes.lat, widget.imagenes.lon),
          icon: BitmapDescriptor.defaultMarker,
      ));
    });
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
                onCameraMove: (position) {
                  setState(() {
                    _position = position;
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.imagenes.lat, widget.imagenes.lon),
                  zoom: widget.imagenes.zoom.toDouble(),
                ),
              ),
              Positioned(
                bottom: screenSize(30.0, context),
                child: GestureDetector(
                  onTap: () => salvarInformacion(),
                  child: Icon(
                    Icons.save,
                    size: screenSize(35.0, context),
                    color: Colors.blue,
                  ),
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

  Future<void> salvarInformacion() async {
    ImagenesModel imagen = widget.imagenes;
    imagen.lat = _position.target.latitude;
    imagen.lon = _position.target.longitude;
    imagen.zoom = _position.zoom.toInt();

    final response = await Provider.of<APITouristServices>(context, listen: false).savePosition(widget.imagenes.idimagenes, imagen, widget.token);

    switch (response.statusCode) {
      case 200:
        Navigator.of(context).pop();
        showSuccessToast(context, 'Mapa', response.body.message);
        break;
    }
  }
}
