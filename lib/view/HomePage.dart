import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webookapp/view/appbar.dart';
import 'package:webookapp/view/navbar.dart';

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key}) : super(key:key);
  @override
  _MyHomePageState createState(){
      return _MyHomePageState();
  }
}
class _MyHomePageState extends State<MyHomePage>{
  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
       title: const Text('Home'),
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
      //bottomNavigationBar: BottomNavBar(),
    );
  }
}