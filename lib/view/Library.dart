import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webookapp/view/appbar.dart';
import 'package:webookapp/view/navbar.dart';

class LibraryPage extends StatefulWidget{
  LibraryPage({Key key}) : super(key:key);
  @override
  _LibraryPageState createState(){
      return _LibraryPageState();
  }
}
class _LibraryPageState extends State<LibraryPage>{

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'My Library Page',
            ),
          ],
        ),
      ),

    );
  }
}