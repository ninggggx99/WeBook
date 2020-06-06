import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view_model/auth_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

//The logout button will be moved to the profile page
class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

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
                      await auth.signOut().then((__) =>  Navigator.pushNamedAndRemoveUntil(context, "/logIn", (r) => false));   
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
