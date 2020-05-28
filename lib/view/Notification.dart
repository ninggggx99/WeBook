import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webookapp/view/appbar.dart';
import 'package:webookapp/view/navbar.dart';

class NotificationPage extends StatefulWidget{
  NotificationPage({Key key}) : super(key:key);
  @override
  _NotificationPageState createState(){
      return _NotificationPageState();
  }
}
class _NotificationPageState extends State<NotificationPage>{

  @override
  Widget build (BuildContext context){
    return Scaffold(
       appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'My Notification Page',
            ),
          ],
        ),
      ),
      //bottomNavigationBar: BottomNavBar(),
    );
  }
}