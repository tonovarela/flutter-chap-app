import 'package:flutter/material.dart';

class BtnAzul extends StatelessWidget {
  final Function onPressed;
  final String label;


  const BtnAzul({Key key, @required this.onPressed,@required this.label}) : super(key: key); 
  

  @override
  Widget build(BuildContext context) {
    return  RaisedButton(
            elevation: 2,
            highlightElevation: 5,
            color:Colors.blue,
            shape: StadiumBorder(),
            child: Container(
              width:double.infinity,
              height: 55,
              child: Center(child: Text(this.label, style:TextStyle( color:Colors.white,fontSize: 17 ))),

            ),
            onPressed: this.onPressed);
  }
}