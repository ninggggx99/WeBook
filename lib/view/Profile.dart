import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view_model/auth_provider.dart';


class ProfilePage extends StatefulWidget{
  ProfilePage({Key key}) : super(key:key);
  @override
  _ProfilePageState createState(){
      return _ProfilePageState();
  }
}
class _ProfilePageState extends State<ProfilePage>{

  @override
  Widget build (BuildContext context){
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: (){
                  auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, "/logIn", (r) => false);
                })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'My Profile Page',
            ),
          ],
        ),
      ),
    );
  }
}