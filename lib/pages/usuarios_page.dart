import 'package:chatapp/models/usuario.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosPage extends StatefulWidget {

  

  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

final usuarios = [
    Usuario( uid: '1',nombre :'Maria',email:"test1@email.com",online: true),
    Usuario( uid: '2',nombre :'Valeria',email:"test2@email.com",online: false),
    Usuario( uid: '3',nombre :'Melissa',email:"test1@email.com",online: true)
];
 RefreshController _refreshController =RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);
    final usuario = _authService.usuario;
    return Scaffold(
       appBar: AppBar(
         centerTitle: true,
         title: Text(usuario.nombre, style: TextStyle(color:Colors.black),),
         
         elevation: 1,
         backgroundColor: Colors.white,
         leading: IconButton(icon: Icon(Icons.exit_to_app,color: Colors.black,) , onPressed: (){
           AuthService.deleteToken();
           Navigator.pushReplacementNamed(context, 'login');
           //desconetarse del socket server
          //_authService
         }),
         actions: [
           Container(
             margin:EdgeInsets.only(right: 10),
             child: Icon(Icons.offline_bolt, color:Colors.blue[400]),
           )
         ],
       ),
       body: SmartRefresher(
         controller: _refreshController,
         enablePullDown: true,
         onRefresh:_cargarUsuarios ,
         header: WaterDropHeader(
           
           complete: Icon(Icons.check, color:Colors.green[400]),
           waterDropColor: Colors.blue[500],
           
         ),
         child: _listViewUsuarios(),

       )
       //_ListViewUsuarios()
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
       physics: BouncingScrollPhysics(),
       itemBuilder: (_,i)=> _usuarioListTile(usuarios[i]),
      separatorBuilder: (_,i) =>Divider(),
       itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(         
       title: Text(usuario.nombre),
       subtitle: Text(usuario.email),
       trailing: Container(
         width: 10,
         height: 10,           
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(100),
           color: usuario.online?Colors.green:Colors.red
         ),

       ),
       leading: CircleAvatar(
         backgroundColor: Colors.blue[100],
         child: Text (usuario.nombre.substring(0,2),         
         ),
       ),
     );
  }


  _cargarUsuarios () async{
    await Future.delayed(Duration(milliseconds: 1000));  
    _refreshController.refreshCompleted();
  }
}