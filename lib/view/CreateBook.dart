import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webookapp/view/appbar.dart';
import 'package:webookapp/view/navbar.dart';

class CreateBookPage extends StatefulWidget{
  CreateBookPage({Key key}) : super(key:key);
  @override
  _CreateBookPageState createState(){
      return _CreateBookPageState();
  }
}
class _CreateBookPageState extends State<CreateBookPage>{

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Book'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'My Create Page',
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}