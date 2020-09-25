import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  const Labels({Key key, @required this.ruta}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(ruta =='register'?'No tienes cuenta?':'',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w300)),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, this.ruta);
            },
            child: Text( ruta=='register'?"Crea una ahora!":"Conectarte con tu cuenta",
                style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
