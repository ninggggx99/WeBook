import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view/EditProfileScreen.dart';
import 'package:webookapp/view/LandingPage.dart';
import 'package:webookapp/view/Profile.dart';
import 'package:webookapp/view/logIn.dart';
import 'package:webookapp/view/BottomNavBar.dart';
import 'package:webookapp/view/signUp.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/download_provider.dart';
import 'package:webookapp/view_model/home_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';
import 'package:webookapp/view_model/notification_provider.dart';

var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
void main() {
  runApp(
    MyApp(),

  );
  // setFirebase();
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

  return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          Provider(create: (_) => HomeProvider()),
          Provider(create: (_) => LibraryProvider()),
          Provider(create: (_) => FileProvider()),
          Provider(create: (_) => DownloadProvider()),
          Provider(create: (_) => NotiProvider()),
        ],
        child: MaterialApp(
            title: 'WeBook',
            /*theme: ThemeData(
              accentColor:  const Color(0x009688),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),*/
            home: LandingPage(),
            routes: {
              '/mainHome':(context) => BottomNavBar(0),
              '/logIn': (context) => LogInPage(),
              '/signUp' : (context) => SignUpPage(),
              '/editProfile': (context) => EditProfileScreen(),
              '/writerProfile':(context) => BottomNavBar(4),
              '/readerProfile':(context) => BottomNavBar(3),
              '/library': (context) => BottomNavBar(1)
            },
            ) 
        );

  }

}


// void setFirebase() {
  

//   var initializationSettingsAndroid =
//   new AndroidInitializationSettings('icon_notif');
  
//   var initializationSettingsIOS = 
//   IOSInitializationSettings();
  
//   var initializationSettings = 
//   InitializationSettings(
//       initializationSettingsAndroid,
//       initializationSettingsIOS);
  
//   flutterLocalNotificationsPlugin
//       .initialize(initializationSettings,
//       onSelectNotification: onSelect);

//   final FirebaseMessaging _firebaseMessaging =
//   FirebaseMessaging();
  
//   _firebaseMessaging.configure(
//     onBackgroundMessage: myBackgroundMessageHandler,
//     onMessage: (message) async {
      
//       print("onMessage: $message");
//       Widget build(context){
//         showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                         content: ListTile(
//                         title: Text(message['notification']['title']),
//                         subtitle: Text(message['notification']['body']),
//                         ),
//                         actions: <Widget>[
//                         FlatButton(
//                             child: Text('Ok'),
//                             onPressed: () => Navigator.of(context).pop(),
//                         ),
//                     ],
//                 ),
//             );   
//       }
//     },
//     onLaunch: (message) async {
//       print("onLaunch: $message");
//     },
//     onResume: (message) async {
//       print("onResume: $message");
//     },
//   );

//   _firebaseMessaging.getToken()
//       .then((String token) {
//     print("Push Messaging token: $token");
//     // Push messaging to this token later
//   });

// }

// Future<String> onSelect(String data) async {
//   print("onSelectNotification $data");
// }
// //updated myBackgroundMessageHandler
// Future<dynamic> myBackgroundMessageHandler(Map<String,
//     dynamic> message) async {
//   print("myBackgroundMessageHandler message: $message");
//   int msgId = int.tryParse(message["data"]["msgId"]
//       .toString()) ?? 0;
//   print("msgId $msgId");
//   var androidPlatformChannelSpecifics = 
//   AndroidNotificationDetails(
//       'your channel id', 'your channel name', 
//       'your channel description', color: Colors.blue.shade800,
//       importance: Importance.Max, 
//       priority: Priority.High, ticker: 'ticker');
//   var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//   var platformChannelSpecifics = NotificationDetails(
//       androidPlatformChannelSpecifics, 
//       iOSPlatformChannelSpecifics);
//   flutterLocalNotificationsPlugin
//       .show(msgId,
//       message["data"]["msgTitle"], 
//       message["data"]["msgBody"], platformChannelSpecifics,
//       payload: message["data"]["data"]);
//   return Future<void>.value();
// }