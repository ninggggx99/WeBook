import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view/LandingPage.dart';
import 'package:webookapp/view/logIn.dart';
import 'package:webookapp/view/navbar.dart';
import 'package:webookapp/view_model/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

  return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: MaterialApp(
            title: 'WeBook',
            theme: ThemeData(
              primarySwatch: Colors.teal,
            ),
            home: LandingPage(),
            routes: {
              '/mainHome': (context) => BottomNavBar(),
              '/login': (context) => LogInPage(),
            },
            )  
        );

  }

}