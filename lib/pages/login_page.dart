import 'package:chatapp/helpers/mostrar_alerta.dart';
import 'package:chatapp/services/auth_service.dart';

import 'package:chatapp/widgets/btn_azul.dart';
import 'package:chatapp/widgets/custom_input.dart';
import 'package:chatapp/widgets/labels.dart';
import 'package:chatapp/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
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
                  Logo( titulo: "Login",),
                  _Form(),
                  Labels( ruta: 'register'),
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
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: "Correo",
            keyboardType: TextInputType.emailAddress,
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
            onPressed: authService.autenticando ? null: () async {    
              FocusScope.of(context).unfocus();
              final loginAction = await authService.login(this.emailCtrl.text.trim(), this.passwordCtrl.text.trim());
              if (loginAction){
                print("Listo");
                Navigator.pushReplacementNamed(context, 'usuarios');
                //Ingresar
              }else{
                mostrarAlerta(context, "Login incorrecto", "Credenciales incorrectas");
                //Mostrar alerta de error

              }

            },
          )
        ],
      ),
    );
  }
}
