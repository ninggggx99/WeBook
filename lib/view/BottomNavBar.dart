import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view/HomePage.dart';
import 'package:webookapp/view/Notification.dart';
import 'package:webookapp/view/Profile.dart';
import 'package:webookapp/view/CreateBook.dart';
import 'package:webookapp/view/Library.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
class BottomNavBar extends StatefulWidget{

  @override
   State<StatefulWidget> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>{
  AuthProvider auth;
  User _user;
  
  void didChangeDependencies(){
    super.didChangeDependencies();
    auth = Provider.of<AuthProvider>(context);
    load();
  }
  void load() async {
    if (auth.user.uid != null) {
      final user = await auth.retrieveUser();
      setState(() {
        _user = user;
      });
    }
    else{
      _user = null;
    }
  }

  int _currentIndex = 0;
  final List <Widget> _writerChildren = [HomePage(),LibraryPage(),CreateBookPage(),NotificationPage(),ProfilePage()];
  final List <Widget> _bookwormChildren = [HomePage(),LibraryPage(),NotificationPage(),ProfilePage()];
  void onTappedBar(int index){
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_user != null){
      return _user.role == "Bookworm" ?  bookwormNavBar():  writerNavBar();
    }
    else{
      return CustomLoadingPage();
    }
   
  }
   Widget bookwormNavBar(){
    return Scaffold(
      body:_bookwormChildren[_currentIndex],
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
  Widget writerNavBar(){
    return Scaffold(
      body:_writerChildren[_currentIndex],
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