import 'package:chatapp/global/env.dart';
import 'package:chatapp/models/mensajes_reponse.dart';
import 'package:chatapp/models/usuario.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  Usuario usuarioPara;
  
  Future<List<Mensaje>> getMensajes(String usuarioID) async{
    final resp =await http.get("${Environment.apiUrl}/mensajes/$usuarioID",
    headers: {
      'x-token': await AuthService.getToken()
    });

    final mensajesResponse= mensajesResponseFromJson(resp.body);
    return mensajesResponse.mensajes;

  }

}