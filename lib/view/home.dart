/*import 'package:flutter/material.dart';
import 'package:webookapp/models/user_model.dart';

class Home extends StatefulWidget {

  const Home({ Key key, @required this.user }) : super(key: key);
  
  final User user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home ${widget.user.fName}'),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:webookapp/database/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:webookapp/model/user_model.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:webookapp/provider/UserProvider.dart';
import 'package:webookapp/view/navbar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("users");

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   final provider = Provider.of<UserProvider>(context);
  // }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Home'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        body: Text("This is nothing"),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //    //TODO
        //   },
        //   tooltip: 'Increment',
        //   child: Icon(Icons.add),
        // ),
        );
  }
}