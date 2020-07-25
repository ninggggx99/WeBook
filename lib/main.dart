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
