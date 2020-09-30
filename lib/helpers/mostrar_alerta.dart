import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(titulo),
              content: Text(subtitulo),
              actions: [
                MaterialButton(
                    elevation: 5,
                    textColor: Colors.blue,
                    child: Text('Ok'),
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  }
  return showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text(titulo),
            content: Text(subtitulo),
            actions: [
              CupertinoDialogAction(
                  child: Text("Ok"),
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context))
            ],
          ));
}
