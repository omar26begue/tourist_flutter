import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/imagenes_model.dart';
import 'package:tourist_flutter/data/models/sitios_model.dart';
import 'package:tourist_flutter/helpers/toasty_msg.dart';
import 'package:tourist_flutter/pages/image_details_screen.dart';

class PlayScreen extends StatefulWidget {
  String token;

  PlayScreen({@required this.token});

  @override
  _PlayScreenState createState() {
    return _PlayScreenState();
  }
}

class _PlayScreenState extends State<PlayScreen> {
  List<SitiosModel> sitios = new List();
  List<ImagenesModel> _imagenes = new List();
  var logger = new Logger();

  @override
  void initState() {
    super.initState();
    cargarSitios();
  }

  Future<void> cargarSitios() async {
    try {
      final response = await Provider.of<APITouristServices>(context, listen: false).listSitios(widget.token);
      logger.i(response.statusCode);

      switch (response.statusCode) {
        case 200:
          for (int i = 0; i < response.body.length; i++) {
            for (int j = 0; j < response.body[i].imagenes.length; j++) {
              ImagenesModel temp = response.body[i].imagenes[j];
              setState(() {
                _imagenes.add(temp);
              });
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
          child: _imagenes.length > 0 ? _galeria() : SizedBox(),
        ),
      ),
    );
  }

  Widget _galeria() {
    return GridView.builder(
      itemCount: _imagenes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ImageDetailsScreen(image: _imagenes[index]);
            }));
          },
          child: Image.network(
              GlobalConfiguration().getBool('app_prod')
                  ? GlobalConfiguration().getString('url_api_prod') + '/storage/' + _imagenes[index].nombre
                  : GlobalConfiguration().getString('url_api_dev') + '/storage/' + _imagenes[index].nombre,
              fit: BoxFit.cover),
        );
      },
    );
  }
}
