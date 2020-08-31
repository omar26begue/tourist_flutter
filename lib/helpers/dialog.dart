import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';

class DialogTourist {
  static showCupertinoDialogError({@required context, @required String title, @required String texto, Function function}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Column(
              children: <Widget>[
                SizedBox(height: screenSize(10.0, context)),
                Image(
                  image: Image.asset("assets/images/icon_app.png").image,
                  //color: Colors.blue.shade800,
                  width: screenSize(100.0, context),
                  height: screenSize(100.0, context),
                ),
                SizedBox(height: screenSize(10.0, context)),
                Text(texto)
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Aceptar"),
                onPressed: () {
                  Navigator.of(context).pop();
                  function();
                },
              )
            ],
          );
        });
  }

  static showCupertinoDialogSuccess({context, String title, String texto, Function btnAceptar}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Column(
              children: <Widget>[
                SizedBox(height: screenSize(10.0, context)),
                Image(
                  image: Image.asset("assets/images/icon_app.png").image,
                  width: screenSize(100.0, context),
                  height: screenSize(100.0, context),
                ),
                SizedBox(height: screenSize(10.0, context)),
                Text(texto)
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Aceptar"),
                onPressed: btnAceptar,
              )
            ],
          );
        });
  }

  static showCupertinoDialogSiNo({context, String title, String texto, Function btnAceptar}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Column(
              children: <Widget>[
                SizedBox(height: screenSize(10.0, context)),
                Image(
                  image: Image.asset("assets/images/icon_app.png").image,
                  //color: Colors.pinkAccent,
                  width: screenSize(100.0, context),
                  height: screenSize(100.0, context),
                ),
                SizedBox(height: screenSize(10.0, context)),
                Text(texto)
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text("Si"),
                onPressed: btnAceptar,
              ),
              CupertinoDialogAction(
                child: Text("No"),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
