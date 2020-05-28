import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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