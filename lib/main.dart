import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view/HomePage.dart';
import 'package:webookapp/view/LandingPage.dart';
import 'package:webookapp/view/logIn.dart';
import 'package:webookapp/view/navbar.dart';
import 'package:webookapp/view/signUp.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

  return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          Provider(create: (_) => FileProvider(),)
        ],
        child: MaterialApp(
            title: 'WeBook',
            theme: ThemeData(
              primarySwatch: Colors.teal,
            ),
            // home: context.watch<AuthProvider>().status == AuthStatus.LOGGED_IN? HomePage():LoginSignupPage(),
            home: LandingPage(),
            routes: {
              '/mainHome':(context) => BottomNavBar(),
              '/logIn': (context) => LogInPage(),
              '/signUp' : (context) => SignUpPage()
            },
            ) 
        );

  }

}