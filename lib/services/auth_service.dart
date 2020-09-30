import 'dart:convert';

import 'package:chatapp/global/env.dart';
import 'package:chatapp/models/login_response.dart';
import 'package:chatapp/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  Usuario usuario;

  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
    return;
  }

  Future<dynamic> register(String email, String password, String name) async {
    final data = {'email': email, 'password': password, "nombre": name};
    this.autenticando = true;
    final resp = await http.post('${Environment.apiUrl}/login/new',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    this.autenticando = false;
    print(resp.body);
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      await this._guardarToken(loginResponse.token);
      this.usuario = loginResponse.usuario;
      return true;
    }
    final respBody = jsonDecode(resp.body);
    return respBody['msg'];
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;
    final data = {'email': email, 'password': password};
    final resp = await http.post('${Environment.apiUrl}/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    print(resp.body);
    this.autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      await this._guardarToken(loginResponse.token);
      this.usuario = loginResponse.usuario;
      return true;
    }
    return false;
  }

  Future<dynamic> isLogin() async {
    final token = await this._storage.read(key: 'token');    
    print(token);
    final resp = await http.get('${Environment.apiUrl}/login/renew',
        headers: {'Content-Type': 'application/json', 'x-token': token});    
        print(resp.body);
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      await this._guardarToken(loginResponse.token);
      this.usuario = loginResponse.usuario;
      return true;
    }
      this._logout();
      return false;
    
  }

  Future _logout() async {
    await this._storage.delete(key: 'token');
    return;
  }

  Future _guardarToken(String token) async {
    await _storage.write(key: 'token', value: token);
    return;
  }
}
