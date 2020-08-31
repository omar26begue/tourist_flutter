import 'package:flutter/material.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - 20.0);
    var firstEndPoint = new Offset(size.width / 4, size.height);
    var firstControlPoint = new Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstEndPoint.dx, firstEndPoint.dy, firstControlPoint.dx, firstControlPoint.dy);
    var secondEndPoint = new Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondControlPoint = new Offset(size.width, size.height - 40.0);
    path.quadraticBezierTo(secondEndPoint.dx, secondEndPoint.dy, secondControlPoint.dx, secondControlPoint.dy);
    path.lineTo(size.width, size.height - 40.0);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
