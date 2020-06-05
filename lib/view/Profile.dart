import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  User _user;
  AuthProvider _auth;

  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
    load();
  }

  void load() async {
    final user = await _auth.retrieveUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.tealAccent.shade700),
          ),
          Container(
            margin: EdgeInsets.only(top: 160.0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Column(
            children: <Widget>[
              //profile picture
              Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white60, width: 2.0),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://i.pinimg.com/originals/c7/2c/a6/c72ca6b569e9729191b465dba7dda209.png'),
                      ),
                    ),
                  ],
                ),
              ),
              (_user == null)
                  ? Container(child: CircularProgressIndicator())
                  : Column(
                      children: <Widget>[
                        Text(
                          _user.firstName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _user.role,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
            ],
          ),
          // settings button
          Align(
            alignment: Alignment(1.4, -1.1),
            child: Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.settings, color: Colors.white),
            ),
          ),
        ],
      ),
    ));
  }
}
