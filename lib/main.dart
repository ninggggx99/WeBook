import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view/LandingPage.dart';
import 'package:webookapp/view_model/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

  return MultiProvider(
        providers: [
          Provider(create: (_) => AuthProvider()),
        ],
        child: MaterialApp(
            title: 'WeBook',
            theme: ThemeData(
              primarySwatch: Colors.teal,
            ),
            home: LandingPage(),
            )  
        );

  }

    

  }
