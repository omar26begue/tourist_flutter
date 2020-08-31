import 'package:flutter/material.dart';
import 'package:tourist_flutter/helpers/constants.dart';
import 'package:tourist_flutter/helpers/session_manager.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    new Future.delayed(_duration, () {
      navigationHome();
    });
  }

  void navigationHome() {
    Future<bool> isLogin = SessionManagerTourist().isLogginTourist();
    isLogin.then((value) => verificarLogeo(value)).catchError((error) =>
        Navigator.of(context).pushReplacementNamed(pageLogin));
  }

  verificarLogeo(bool value) async {
    if (value) {
      Navigator.of(context).pushReplacementNamed(pageHome);
    } else {
      Navigator.of(context).pushReplacementNamed(pageLogin);
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: size.width,
            height: size.height,
            child: Center(
              child: Image(
                width: screenSize(200.0, context),
                height: screenSize(200.0, context),
                image: Image.asset("assets/images/icon_app.png").image,
              ),
            ),
          )
        ],
      ),
    );
  }
}
