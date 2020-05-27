import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/database/authentication.dart';
import 'package:webookapp/view/home.dart';
import 'package:webookapp/view/login_signup_view.dart';
import 'package:webookapp/view_model/auth_provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // retrieve firebaseAuth from above in the widget tree
    
    final auth = Provider.of<AuthProvider>(context);
    if (auth.status == AuthStatus.LOGGED_IN){
      return HomePage();
    }
    else if (auth.status == AuthStatus.NOT_LOGGED_IN){
      return LoginSignupPage();
    }
    else{
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator() ,
          )
    );
    }
  }
}