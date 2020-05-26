import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webookapp/model/user_model.dart';

abstract class BaseAuth {

  Future<String> signIn(String email, String password);

  Future<String> signUp(String firstName, String lastName, String email, String password, String role);

  Future<FirebaseUser> signInWithGoogle();

  Future<String> addUserToDB(FirebaseUser user, String role);

  Future<String> signUpWithGoogle(String role);

  Future<void> signOutGoogle();

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();

}

class Auth implements BaseAuth {
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("users");

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String firstName, String lastName, String email, String password, String role) async {

    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;

    User acc = User(firstName, lastName, email, role);
    dbRef.child(user.uid).set(acc.toJson());

    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

Future<FirebaseUser> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _firebaseAuth.currentUser();
  assert(user.uid == currentUser.uid);

  print('signInWithGoogle succeeded: $user');
  print('this is the displau name: ${currentUser.displayName}');
  return currentUser;
}

Future<String> addUserToDB(FirebaseUser user, String role) async {
  
  User acc = User(user.displayName, " ", user.email, role);
  dbRef.child(user.uid).set(acc.toJson());

  return user.uid;
}

Future<String> signUpWithGoogle(String role) async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _firebaseAuth.currentUser();
  assert(user.uid == currentUser.uid);
 
  User acc = User(currentUser.displayName, " ", currentUser.email, role);
  dbRef.child(user.uid).set(acc.toJson());


  print('signInWithGoogle succeeded: $user');
  return currentUser.uid;
}

Future<void> signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Sign Out");
}


}