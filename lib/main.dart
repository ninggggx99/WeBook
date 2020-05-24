import 'package:flutter/material.dart';
import 'package:webookapp/view/navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeBook',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BottomNavBar(),
    );
  }
}
