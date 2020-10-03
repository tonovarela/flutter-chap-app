import 'package:chatapp/helpers/mostrar_alerta.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/services/socket_service.dart';
import 'package:chatapp/widgets/btn_azul.dart';
import 'package:chatapp/widgets/custom_input.dart';
import 'package:chatapp/widgets/labels.dart';
import 'package:chatapp/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height *.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(titulo:"Registro",),
                  _Form(),
                  Labels( ruta: 'login'),
                  Text(
                    "Términos y condiciones de uso",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nombreCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: "Nombre",            
            textController: nombreCtrl,
          ),
          CustomInput(
            icon: Icons.email,
            placeholder: "Email",            
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: "Password",
            keyboardType: TextInputType.visiblePassword,
            textController: passwordCtrl,
            isPassword: true,
          ),
          BtnAzul(
            label: 'Ingresar',
            onPressed:authService.autenticando?null:() async {
              final registerAction = await authService.register(this.emailCtrl.text.trim(), this.passwordCtrl.text.trim(),this.nombreCtrl.text.trim());
              FocusScope.of(context).unfocus();
              if (registerAction==true){
                print("Listo");
                Navigator.pushReplacementNamed(context, 'usuarios');
                socketService.connect();
                //Ingresar
              }else{
                mostrarAlerta(context, "Registro incorrecto", registerAction);
                //Mostrar alerta de error

              }
              print('Ejecutado');

            },
          )
        ],
      ),
    );
  }
}
