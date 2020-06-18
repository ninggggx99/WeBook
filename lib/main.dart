import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view/EditProfileScreen.dart';
import 'package:webookapp/view/LandingPage.dart';
import 'package:webookapp/view/logIn.dart';
import 'package:webookapp/view/navbar.dart';
import 'package:webookapp/view/signUp.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/home_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:webookapp/view_model/library_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

  return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          Provider(create: (_) => HomeProvider()),
          Provider(create: (_) => LibraryProvider()),
          Provider(create: (_) => FileProvider(),)
        ],
        child: MaterialApp(
            title: 'WeBook',
            theme: ThemeData(
              accentColor:  const Color(0x009688),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            home: LandingPage(),
            routes: {
              '/mainHome':(context) => BottomNavBar(),
              '/logIn': (context) => LogInPage(),
              '/signUp' : (context) => SignUpPage(),
              '/editProfile': (context) => EditProfileScreen(),
            },
            ) 
        );

  }

}