import 'package:flutter/material.dart';
import 'package:tourist_flutter/data/models/comentarios_model.dart';
import 'package:tourist_flutter/helpers/utils_size.dart';

class CardComentariosWidget extends StatefulWidget {
  ComentariosModel comentarios;

  CardComentariosWidget({@required this.comentarios});

  @override
  _CardComentariosWidgetState createState() {
    return _CardComentariosWidgetState();
  }
}

class _CardComentariosWidgetState extends State<CardComentariosWidget> {
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
    return Card(
      color: Colors.white,
      elevation: 5.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.comentarios.texto,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: screenSize(12.0, context)),
            ),
          ),
          SizedBox(height: screenSize(10.0, context)),
          Text(
            widget.comentarios.fullname + ', ' + widget.comentarios.fecha,
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.grey, fontSize: screenSize(10.0, context)),
          )
        ],
      ),
    );
  }
}
