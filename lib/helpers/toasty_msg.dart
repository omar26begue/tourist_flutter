import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar showSuccessToast(BuildContext context, String titulo, String message) {
  return Flushbar(
    title: titulo,
    message: message,
    icon: Icon(
      Icons.check,
      size: 28.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.green[600], Colors.green[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}

Flushbar showErrorToast(BuildContext context, String titulo, String message) {
  return Flushbar(
    title: titulo,
    message: message,
    icon: Icon(
      Icons.error,
      size: 28.0,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.red[600], Colors.red[400]],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}

Flushbar showInfoToast(BuildContext context, String titulo, String message) {
  return Flushbar(
    title: titulo,
    message: message,
    icon: Icon(
      Icons.error,
      size: 28.0,
      color: Colors.blueAccent,
    ),
    duration: const Duration(seconds: 4),
    backgroundGradient: LinearGradient(
      colors: [Colors.black, Colors.black87],
    ),
    onTap: (flushbar) => flushbar.dismiss(),
  )..show(context);
}