import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/notification_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view/HomePage.dart';
import 'package:webookapp/view/Notification.dart';
import 'package:webookapp/view/Profile.dart';
import 'package:webookapp/view/CreateBook.dart';
import 'package:webookapp/view/Library.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/notification_provider.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
class BottomNavBar extends StatefulWidget{

  @override
   _BottomNavBarState createState() => _BottomNavBarState();
  
  final int index;
  BottomNavBar(this.index);
}

class _BottomNavBarState extends State<BottomNavBar>{
  AuthProvider auth;
  NotiProvider noti;
  User _user;
  int _currentIndex = 0;
  // List<Message> _message;
  void didChangeDependencies(){
    super.didChangeDependencies();
    auth = Provider.of<AuthProvider>(context);
    noti = Provider.of<NotiProvider>(context);
    load();
  }
  void load() async {
    if (auth.user.uid != null) {
      final user = await auth.retrieveUser();
      setState(() {
        _user = user;
        _currentIndex = widget.index;
      });
    }
    else{
      _user = null;
    }
  }
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  // StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    // Message _message;
    
    

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        await _savingNoti(message);
        final snackbar = SnackBar(
          duration: const Duration(minutes:2),
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'Go',
            onPressed: () async {
              if(_user.role == "Bookworm"){
                onTappedBar(2);
              }
              else{
                onTappedBar(3);
              }
            },
          ),
        );
        print("Snackbar");
        _scaffoldKey.currentState.showSnackBar(snackbar);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        await _savingNoti(message);
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        await _savingNoti(message);
        if(_user.role == "Bookworm"){
          onTappedBar(2);
        }
        else{
          onTappedBar(3);
        }

        // TODO optional
      },
    );
  }
  
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
      key: _scaffoldKey,
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
      key: _scaffoldKey,
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

Future<void> _savingNoti (Map<String,dynamic> message) async{
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference().child("notifications");
  final notification = message['notification'];
  final data = message['data'];
  bool exist = false;
  await _dbRef.child(data["authorId"]).once().then((DataSnapshot snapshot){
    if (snapshot.value != null) {
      Map<dynamic, dynamic> maps = Map.from(snapshot.value);
      maps.forEach((key, value) {
        Message m = Message.fromJson(Map.from(value));
        if (m.commentId == data['commentId']){
          exist = true;
        }
      });
    }
  });
  if (exist == false){
    Message _message = new Message(
                title: notification['title'],
                body: notification['body'],
                dateTime: DateTime.fromMillisecondsSinceEpoch(int.parse(data['commentDate'])),
                userId: data['commentUserId'],
                bookId: data['bookId'],
                commentId: data['commentId']
              );
    String key = _dbRef.child(data["authorId"]).push().key;
    await _dbRef.child(data["authorId"]).child(key).set(_message.toJson());
    print("saved noti");
  }
  else{
    print("duplicated");
  }
 
}