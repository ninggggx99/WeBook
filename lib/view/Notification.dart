import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/notification_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);
  @override
  _NotificationPageState createState() {
    return _NotificationPageState();
  }
}

class _NotificationPageState extends State<NotificationPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final List<Message> notifications = [];

  @override
  void initState(){
    super.initState();
    _fcm.configure(
      onMessage : (Map<String,dynamic> message) async{
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          notifications.add(Message(
              title: notification['title'],
              body: notification['body']
            ),           
          );
        }); 
        print(notifications);
      },
      onLaunch: (Map<String, dynamic> message) async{
        print ("onLaunch: $message");
        final notification = message['notification'];
        setState(() {
          notifications.add(Message(
              title: 'OnLaunch: ${notification['title']}',
              body: 'OnLaunch: ${notification['body']}'
            ),           
          );
        }); 
        print(notifications);
      },
      onResume: (Map<String, dynamic> message) async{
        print ("onResume: $message");
      },
    );
    
  }
  @override
  Widget build (BuildContext context){
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: ListView(
          children: notifications.map(buildMessage).toList(),
          
        ),
      )
    );
  }
  Widget buildMessage(Message notim){
    return ListTile(
      title: Text(notim.title),
      subtitle: Text(notim.body)
    );
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _saveDeviceToken();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Notification'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text(
  //             'My Notification Page',
  //           ),
  //         ],
  //       ),
  //     ),
  //     //bottomNavigationBar: BottomNavBar(),
  //   );
  // }

  // /// Get the token, save it to the database for current user
  // _saveDeviceToken() async {
  //   String uid = "YiTgZmPt5eV8gYhxqVGI8tDO8RJ2";
  //   // Get the token for this device
  //   String fcmToken = await _fcm.getToken();
  //   print(fcmToken);

  //   // Save it to Firestore
  //   if (fcmToken != null) {
  //     await _dbRef.child('users/$uid/token').set(fcmToken);
  //   }
  // }
}
