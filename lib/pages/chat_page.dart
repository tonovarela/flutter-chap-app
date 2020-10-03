import 'dart:io';

import 'package:chatapp/models/mensajes_reponse.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/chat_service.dart';
import 'package:chatapp/services/socket_service.dart';
import 'package:chatapp/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  bool _estaEscribiendo = false;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(this.chatService.usuarioPara.uid);

    super.initState();
  }

  _cargarHistorial(String uid) async {
    List<Mensaje> chat = await this.chatService.getMensajes(uid);
    final historial = chat.map((m) => ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: new AnimationController(
            vsync: this, duration: Duration(milliseconds: 0))
          ..forward()));
    setState(() {
      this._messages.insertAll(0, historial);
    });
    print(chat);
  }

  _escucharMensaje(dynamic payload) {
    //print('tengo un mensaje $payload');
    ChatMessage m = new ChatMessage(
      texto: payload["mensaje"],
      uid: payload["de"],
      animationController:
          AnimationController(vsync: this, duration: Duration(milliseconds: 2)),
    );
    setState(() {
      _messages.insert(0, m);
    });
    m.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 15,
              backgroundColor: Colors.blue[100],
              child: Text(
                usuario.nombre.substring(0, 2),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(usuario.nombre,
                style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _messages.length,
                  reverse: true,
                  itemBuilder: (_, i) => _messages[i]),
            ),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmited,
              onChanged: (String texto) {
                setState(() {
                  if (texto.trim().length > 0) {
                    _estaEscribiendo = true;
                  } else {
                    _estaEscribiendo = false;
                  }
                });
              },
              focusNode: _focusNode,
              decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text("Enviar"),
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmited(_textController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Icon(Icons.send),
                            onPressed: _estaEscribiendo
                                ? () =>
                                    _handleSubmited(_textController.text.trim())
                                : null,
                          )),
                    ))
        ],
      ),
    ));
  }

  _handleSubmited(String texto) {
    //print(texto);
    final newMessage = new ChatMessage(
        uid: this.authService.usuario.uid,
        texto: texto,
        animationController: AnimationController.unbounded(
            vsync: this, duration: Duration(milliseconds: 400)));

    setState(() {
      _estaEscribiendo = false;
      _messages.insert(0, newMessage);
      newMessage.animationController.forward(from: 0.5);
      this._textController.clear();
      this._focusNode.requestFocus();
    });
    this.socketService.emit('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    //desconectar socket
    _messages.forEach((message) => message.animationController.dispose());
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
