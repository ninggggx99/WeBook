import 'package:flutter/material.dart';
import 'package:webookapp/view/HomePage.dart';
import 'package:webookapp/view/Notification.dart';
import 'package:webookapp/view/Profile.dart';
import 'package:webookapp/view/CreateBook.dart';
import 'package:webookapp/view/Library.dart';
class BottomNavBar extends StatefulWidget{
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}
class _BottomNavBarState extends State<BottomNavBar>{
  int _currentIndex = 0;
  final List <Widget> _children = [MyHomePage(),LibraryPage(),CreateBookPage(),NotificationPage(),ProfilePage()];
  void onTappedBar(int index){
    setState(() {
      _currentIndex= index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:_children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        type:BottomNavigationBarType.fixed,
        items:
        [
          BottomNavigationBarItem
          (
            icon: new Icon(Icons.home),
            title: new Text ("Home")
          ),
          BottomNavigationBarItem
          (
            icon: new Icon(Icons.library_books),
            title: new Text ("Library")
          ),
          BottomNavigationBarItem
          (
            icon: new Icon(Icons.create),
            title: new Text ("Create")
          ),
          BottomNavigationBarItem
          (
            icon: new Icon(Icons.notifications),
            title: new Text ("Notification")
          ),
          BottomNavigationBarItem
          (
            icon: new Icon(Icons.person),
            title: new Text ("Profile")
          ),
        ]
      ),
    );
  }
  
}