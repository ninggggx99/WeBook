import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view/LandingPage.dart';
import 'package:webookapp/view/home.dart';
import 'package:webookapp/view/login_signup_view.dart';
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
            // home: context.watch<AuthProvider>().status == AuthStatus.LOGGED_IN? HomePage():LoginSignupPage(),
            home: LandingPage(),
            )  
        );

  }

    

  }
