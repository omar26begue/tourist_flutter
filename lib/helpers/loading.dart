import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ShowLoadingTourist extends StatefulWidget {
  bool loading;

  ShowLoadingTourist({this.loading});

  @override
  _ShowLoadingTouristState createState() {
    return _ShowLoadingTouristState();
  }
}

class _ShowLoadingTouristState extends State<ShowLoadingTourist> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return widget.loading == true
        ? Positioned(
            child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(color: Colors.black54),
              child: LottieBuilder.asset(
                "assets/10934-loading.json",
                fit: BoxFit.contain,
                width: size.width,
                height: size.height,
              ),
            ),
          )
        : SizedBox();
  }
}
