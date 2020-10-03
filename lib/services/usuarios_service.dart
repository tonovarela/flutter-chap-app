import 'package:chatapp/global/env.dart';
import 'package:chatapp/models/usuario.dart';
import 'package:chatapp/models/usuarios_response.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get('${Environment.apiUrl}/usuarios',headers: {
        'x-token': await AuthService.getToken()
      });
      final usuariosResponse = usuariosResponseFromJson(resp.body);
       return usuariosResponse.usuarios;

    } catch (e) {
      return [];
    }
  }
}
