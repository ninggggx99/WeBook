import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth;

  FirebaseUser _user;
  FirebaseUser get user => _user;

  AdditionalUserInfo _additionalUserInfo;
  AdditionalUserInfo get additionalUserInfo => _additionalUserInfo;

  AuthStatus _status;
  AuthStatus get status => _status;

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _status = AuthStatus.NOT_DETERMINED;
    notifyListeners();

    _user = await FirebaseAuth.instance.currentUser();

    _status = _user == null ? AuthStatus.NOT_LOGGED_IN: AuthStatus.LOGGED_IN;
    notifyListeners();
  }

  Future<AuthResult> createUser({String email, String password}) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await signOut();
    notifyListeners();
    return result;
  }

  Future<bool> signInWithEmail({String email, String password}) async =>
      _signIn(await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ));

  Future<bool> signInWithCredential(AuthCredential credential) async =>
      _signIn(await _auth.signInWithCredential(credential));

  bool _signIn(AuthResult result) {
    _user = result.user;
    _additionalUserInfo = result.additionalUserInfo;
    notifyListeners();
    return result.user == null ? false : true;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

}
