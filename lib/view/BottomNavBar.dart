import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:webookapp/view/HomePage.dart';
import 'package:webookapp/view/Notification.dart';
import 'package:webookapp/view/Profile.dart';
import 'package:webookapp/view/CreateBook.dart';
import 'package:webookapp/view/Library.dart';
class BottomNavBar extends StatefulWidget{

  @override
   State<StatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>{
  int _currentIndex = 0;
  final List <Widget> _children = [HomePage(),LibraryPage(),CreateBookPage(),NotificationPage(),ProfilePage()];
  void onTappedBar(int index){
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body:_children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0x009688).withOpacity(0.7),
        unselectedItemColor: Colors.grey.withOpacity(0.6),
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        type:BottomNavigationBarType.fixed,
        items:
        [
          BottomNavigationBarItem
          (
            icon: new Icon(Icons.home),
            title: Text("")
          ),
          BottomNavigationBarItem
          (
            icon: new Icon(Icons.library_books),
            title: new Text ("")
          ),
          BottomNavigationBarItem
          (
            icon: new Icon(Icons.create),
            title: new Text ("")
          ),
          BottomNavigationBarItem
          (
            icon: new Icon(Icons.notifications),
            title: new Text ("")
          ),
          BottomNavigationBarItem
          (
            icon: new Icon(Icons.person),
            title: new Text ("")
          ),
        ]
      ),
    );
  }
  
}