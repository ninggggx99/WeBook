import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view/LandingPage.dart';
import 'package:webookapp/view/logIn.dart';
import 'package:webookapp/view_model/auth_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Home'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: (){
                  logout() async{
                      await auth.signOut().then((__) =>  Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false));   
                  }
                  logout();                            
                 
                }),
          ],
        ),
       body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'My Home Page',
            ),
          ],
        ),
      ),

    );
  }
}