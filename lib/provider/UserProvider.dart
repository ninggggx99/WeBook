// import 'package:flutter/cupertino.dart';
// import 'package:webookapp/model/user_model.dart';
// import 'package:webookapp/database/authentication.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class UserProvider with ChangeNotifier{
//   UserProvider({this.auth});
//   final BaseAuth auth;
//   String userid;
//   bool isLoggedIn;
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//   void getUser() async {
//     FirebaseUser user = await firebaseAuth.currentUser();
//     userid= (user.uid).toString();
//   }
//   void checkState(){
//     isLoggedIn = false;
//      firebaseAuth.currentUser().then((user) => user != null
//         ? isLoggedIn = true : isLoggedIn = false);
//     notifyListeners();
//   }
  
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///
  /// return the Future with firebase user object FirebaseUser if one exists
  ///
  Future<FirebaseUser> getUser() {
    return _auth.currentUser();
  }

  // wrapping the firebase calls
  Future logout() async {
    var result = FirebaseAuth.instance.signOut();
    notifyListeners();
    return result;
  }
  
  ///
  /// wrapping the firebase call to signInWithEmailAndPassword
  /// `email` String
  /// `password` String
  ///
  Future<FirebaseUser> loginUser({String email, String password}) async {
    var result;
    try {
      result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // since something changed, let's notify the listeners...
      notifyListeners();
      return result;
    }  catch (e) {
      // throw the Firebase AuthException that we caught
      throw new AuthException(e.code, e.message);
    }
  }
}