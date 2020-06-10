import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:webookapp/view/logIn.dart';
import 'package:webookapp/view/navbar.dart';

import 'package:webookapp/view_model/auth_provider.dart';
// import 'package:webookapp/database/authentication.dart';
// import 'package:webookapp/view/login_signup_view.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // retrieve firebaseAuth from above in the widget tree
    
    final auth = Provider.of<AuthProvider>(context);
    if (auth.status == AuthStatus.LOGGED_IN){
      return BottomNavBar();
    }
    else if (auth.status == AuthStatus.NOT_LOGGED_IN){
      return LogInPage();
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