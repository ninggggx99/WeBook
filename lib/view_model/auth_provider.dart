import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
/*import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; */

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AuthProvider extends ChangeNotifier {

  DatabaseReference _dbRef;
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn;
  //FacebookLogin _facebookLogin;

  FirebaseUser _user;
  FirebaseUser get user => _user;

  AdditionalUserInfo _additionalUserInfo;
  AdditionalUserInfo get additionalUserInfo => _additionalUserInfo;

  AuthStatus _status;
  AuthStatus get status => _status;

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _dbRef = FirebaseDatabase.instance.reference();
    _googleSignIn = GoogleSignIn();
    //_facebookLogin = FacebookLogin();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _status = AuthStatus.NOT_DETERMINED;
    notifyListeners();

    _user = await FirebaseAuth.instance.currentUser();

    _status = _user == null ? AuthStatus.NOT_LOGGED_IN: AuthStatus.LOGGED_IN;
    notifyListeners();
  }

  /*Future<User> retrieveUserData() async {
    _user = await FirebaseAuth.instance.currentUser();
    _dbRef.child("users").
  }*/
  /*Future<AuthResult> createUser({String email, String password}) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await signOut();
    notifyListeners();
    return result;
  }*/

  Future<void> insertUser(String firstName, String lastName, String email, String role) async {
    //Convert to the user model and insert into db
    User acc = User(firstName, lastName, email, role);
    _dbRef.child("users").child(user.uid).set(acc.toJson());
    print("${acc.firstName}");

  }

  Future<User> retrieveUser() async {
    //Retrieve a snapshot of the user data from the database
    User acc;
    _dbRef.child("users").once().then((DataSnapshot snapshot) {
      acc = User.fromSnapShot(snapshot);
    });
    return acc;
  }

  Future<AuthResult> createUser({String firstName, String lastName, String email, String password, String role}) async {
    
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await insertUser(firstName, lastName, email, role);

    await signOut();
    notifyListeners();
    return result;

  }

  Future<bool> signInWithEmail({String email, String password}) async =>
      _signIn(await _auth.signInWithEmailAndPassword(
        email: email,
        password: password, 
      ));

  Future<bool> signInWithGoogle() async {

    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    print("Success Google Sign In");

    return signInWithCredential(credential);
  }

  /*Future<bool> signInWithFB() async {
    
    FacebookLoginResult result = await _facebookLogin.logIn(["email"]);
    print(result.status);

    switch (result.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken accessToken = result.accessToken;
        AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: accessToken.token);
        await signInWithCredential(credential);
        print("LoggedIn");

        break;
    }
  }*/
      
  Future<bool> signInWithCredential(AuthCredential credential) async =>
      _signIn(await _auth.signInWithCredential(credential));

  bool _signIn(AuthResult result) {
    _user = result.user;
    _additionalUserInfo = result.additionalUserInfo;
    notifyListeners();
    return result.user == null ? false : true;
  }

  Future<void> signUpWithGoogle(String role) async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await _auth.signInWithCredential(credential);
    await insertUser(user.displayName, " ", user.email, role);

    print('signUpWithGoogle succeeded: ${user.uid}');
  }

  /*Future<void> signUpWithFB(String role) async {
    final result = await _facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = json.decode(graphResponse.body);
    await insertUser(profile.first_name, profile.last_name, profile.email, role);

    print('signUpWithFB succeeded: $user');
  }*/

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    //await _facebookLogin.logOut();
    notifyListeners();
  }

}
