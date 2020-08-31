import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tourist_flutter/data/api_tourist_services.dart';
import 'package:tourist_flutter/data/models/tourist_model.dart';
import 'package:tourist_flutter/helpers/constants.dart';
import 'package:tourist_flutter/pages/home_screen.dart';
import 'package:tourist_flutter/pages/login_screen.dart';
import 'package:tourist_flutter/pages/splash_screen.dart';

class AppTourist extends StatefulWidget {
  @override
  _AppTouristState createState() {
    return _AppTouristState();
  }
}

class _AppTouristState extends State<AppTourist> {
  final _touristModel = new TouristModel();

  @override
  void initState() {
    super.initState();
    cargarConfiguracion();
  }

  void cargarConfiguracion() async {
    await GlobalConfiguration().loadFromAsset('app_settings.json');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => APITouristServices.create(),
      dispose: (_, APITouristServices service) => service.dispose(),
      child: ScopedModel<TouristModel>(
        model: _touristModel,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: pageSplash,
          routes: {
            pageSplash: (BuildContext context) => SplashScreen(),
            pageLogin: (BuildContext context) => LoginScreen(),
            pageHome: (BuildContext context) => HomeScreen(),
          },
        ),
      ),
    );
  }
}
