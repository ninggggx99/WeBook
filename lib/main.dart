import 'package:flutter/material.dart';
import 'package:webookapp/view/HomePage.dart';
import 'package:webookapp/view/Notification.dart';
import 'package:webookapp/view/Profile.dart';
import 'package:webookapp/view/CreateBook.dart';
import 'package:webookapp/view/Library.dart';
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
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes:{
        '/': (context) => MyHomePage(),
        '/notification': (context) => NotificationPage(),
        '/library': (context) => LibraryPage(),
        '/createbook':  (context) => CreateBookPage(),
        '/profile': (context) => ProfilePage(),
      }
    );
  }
}
