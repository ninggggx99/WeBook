import 'package:flutter/material.dart';
import 'package:webookapp/view/navbar.dart';
import 'package:webookapp/view_model/root_vm.dart';

import 'database/authentication.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeBook',
      // title: 'Welcome',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // home: BottomNavBar(),
    home: new RootPage(auth: new Auth()));
  }
}