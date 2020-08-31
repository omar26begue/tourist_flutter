import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:share/share.dart';
import 'package:tourist_flutter/data/models/imagenes_model.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';

class ImageDetailsScreen extends StatefulWidget {
  ImagenesModel image;

  ImageDetailsScreen({@required this.image});

  @override
  _ImageDetailsScreenState createState() {
    return _ImageDetailsScreenState();
  }
}

class _ImageDetailsScreenState extends State<ImageDetailsScreen> {
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
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            child: Image.network(
                GlobalConfiguration().getBool('app_prod')
                    ? GlobalConfiguration().getString('url_api_prod') + '/storage/' + widget.image.nombre
                    : GlobalConfiguration().getString('url_api_dev') + '/storage/' + widget.image.nombre,
                fit: BoxFit.cover),
          ),
          Positioned(
            top: screenSize(50.0, context),
            left: screenSize(15.0, context),
            child: Container(
              padding: EdgeInsets.all(screenSize(7.0, context)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Colors.blue.shade500,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: screenSize(30.0, context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
