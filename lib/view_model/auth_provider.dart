import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

enum AuthError{
  ERROR_INVALID_EMAIL,
  ERROR_WRONG_PASSWORD,
  ERROR_USER_NOT_FOUND,
  ERROR_USER_DISABLED,
  ERROR_TOO_MANY_REQUESTS,
  ERROR_OPERATION_NOT_ALLOWED,
  ERROR_UNKNOWN,
}

class AuthProvider extends ChangeNotifier {

  DatabaseReference _dbRef;
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn;

  FirebaseUser _user;
  FirebaseUser get user => _user;

  AdditionalUserInfo _additionalUserInfo;
  AdditionalUserInfo get additionalUserInfo => _additionalUserInfo;

  AuthStatus _status;
  AuthStatus get status => _status;

  AuthError _error;
  AuthError get error => _error;

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _dbRef = FirebaseDatabase.instance.reference();
    _googleSignIn = GoogleSignIn();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _status = AuthStatus.NOT_DETERMINED;
    notifyListeners();

    _user = await FirebaseAuth.instance.currentUser();

    _status = _user == null ? AuthStatus.NOT_LOGGED_IN: AuthStatus.LOGGED_IN;
    notifyListeners();
  }

  /*Future<AuthResult> createUser({String email, String password}) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await signOut();
    notifyListeners();
    return result;
  }*/

  Future<AuthResult> createUser({String firstName, String lastName, String email, String password, String role}) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    //Convert to the user model and insert into db
    FirebaseUser user = result.user;
    User acc = User(firstName, lastName, email, role);
    _dbRef.child("users").child(user.uid).set(acc.toJson());

    print("${user.uid}");
    print("${acc.firstName}");
    print("${acc.role}");

    await signOut();
    notifyListeners();
    return result;

  }

  // Future<bool> signInWithEmail({String email, String password}) async =>
  //     _signIn(await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password, 
  //     ));
  Future <bool> signInWithEmail({String email, String password}) async{
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = result.user;
      _additionalUserInfo = result.additionalUserInfo;
      notifyListeners();
    }catch(e){
      print(e.code);
      switch(e.code){
        case "ERROR_INVALID_EMAIL":
          _error = AuthError.ERROR_INVALID_EMAIL;
          break;
        case "ERROR_WRONG_PASSWORD":
          _error = AuthError.ERROR_WRONG_PASSWORD;
          break;
        case "ERROR_USER_NOT_FOUND":
          _error = AuthError.ERROR_USER_NOT_FOUND;
          break;
        case "ERROR_USER_DISABLED":
          _error = AuthError.ERROR_USER_DISABLED;
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          _error = AuthError.ERROR_TOO_MANY_REQUESTS;
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          _error = AuthError.ERROR_OPERATION_NOT_ALLOWED;
          break;
        default:
          _error = AuthError.ERROR_UNKNOWN;
          break;
      }
      notifyListeners();
      
    }
    return _user == null ? false : true;
  }

  // Future<bool> signInWithGoogle() async {

  //   GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  //   GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;

  //   AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );

  //   return signInWithCredential(credential);
  // }
      
  // Future<bool> signInWithCredential(AuthCredential credential) async =>
  //     _signIn(await _auth.signInWithCredential(credential));

  // bool _signIn(AuthResult result) {
  //   _user = result.user;
  //   _additionalUserInfo = result.additionalUserInfo;
  //   notifyListeners();
  //   return result.user == null ? false : true;
  // }

  Future<String> signUpWithGoogle(String role) async {
  final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
 
  User acc = User(currentUser.displayName, " ", currentUser.email, role);
  _dbRef.child("users").child(user.uid).set(acc.toJson());


  print('signUpWithGoogle succeeded: $user');
  return currentUser.uid;
}


  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

}
