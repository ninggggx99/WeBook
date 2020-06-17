import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


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
  ERROR_INVALID_CREDENTIAL,
  ERROR_REQUIRES_RECENT_LOGIN
}

class AuthProvider extends ChangeNotifier {

  DatabaseReference _dbRef;
  FirebaseAuth _auth;
  FirebaseStorage _storage;
  GoogleSignIn _googleSignIn;
  FacebookLogin _facebookLogin;
  

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
    _storage = FirebaseStorage(storageBucket: "gs://webook-a430e.appspot.com");
    _googleSignIn = GoogleSignIn();
    _facebookLogin = FacebookLogin();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _status = AuthStatus.NOT_DETERMINED;
    notifyListeners();

    _user = await FirebaseAuth.instance.currentUser();

    _status = _user == null ? AuthStatus.NOT_LOGGED_IN: AuthStatus.LOGGED_IN;
    notifyListeners();
  }

  Future<void> insertUser(String firstName, String lastName, String email, String role) async {
    //Convert to the user model and insert into db
    User acc = new User(" ", firstName, lastName, email, role);
    _dbRef.child("users").child(user.uid).set(acc.toJson());

  }

  Future<User> retrieveUser() async{
    //Retrieve a snapshot of the user data from the databaseF
    User acc;
    await _dbRef.child("users").child(user.uid).once().then((DataSnapshot snapshot) {
      acc = User.fromSnapShot(snapshot);
    });

    return acc;

  }

  Future<User> findUser(String userId) async {
   
    User acc;
    await _dbRef.child("users").child(userId).once().then((DataSnapshot snapshot) {
      acc = User.fromSnapShot(snapshot);
    });
    
    return acc;
  }

  Future<AuthResult> createUser({String firstName, String lastName, String email, String password, String role}) async {
    
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    _user = result.user;
    await insertUser(firstName, lastName, email, role);

    print("${user.uid}");

    await signOut();
    notifyListeners();
    return result;

  }

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

  Future<bool> signInWithFB() async {
    
    FacebookLoginResult result = await _facebookLogin.logIn(["email"]);
    print(result.status);

    switch (result.status) {
      case FacebookLoginStatus.error:
        print("Error");
        return false;
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        return false;
        break;
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken accessToken = result.accessToken;
        AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: accessToken.token);
        print("LoggedIn");
        return signInWithCredential(credential);
        break;
      default: 
        return false;
    } 
  }
      
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

    await signInWithCredential(credential);
    await insertUser(user.displayName, " ", user.email, role);

    print('signUpWithGoogle succeeded: ${user.uid}');
  }

  Future<void> signUpWithFB(String role) async {
    
    final result = await _facebookLogin.logIn(['email']);
    print(result.status);
    final token = result.accessToken.token;
    AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: token);

    await signInWithCredential(credential);
    print(user);
    await insertUser(user.displayName, " ", user.email, role);

    print('signUpWithFB succeeded: $user');

  }


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

  //This can update and insert a new profile pic
  Future<void> uploadProfilePic(User user, String filePath) async {

    String fileName = filePath.split('/').last;
    String _extension = fileName.split(".").last;
    StorageReference storageReference = _storage.ref().child("profile");
    //Uploading the image
    StorageUploadTask uploadTask = storageReference.child("${user.key}").putFile(File(filePath), StorageMetadata(contentType: 'image/$_extension'));
    
    //Getting the image url
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();

    await _dbRef.child("users/${user.key}").child("profilePic").set(url);
  }

  Future<void> updateFirstName (String first) async{
    await _dbRef.child("users/${user.uid}/firstName").set(first);
  }
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    
    //Require reauthentication 
    try{
      AuthCredential credential = EmailAuthProvider.getCredential(email:user.email,password:oldPassword);
      AuthResult result = await user.reauthenticateWithCredential(credential);
      await result.user.updatePassword(newPassword);
      print("Password updated");
      return true;
    }
    catch (e){
      print(e.code);
      switch(e.code){
        case "ERROR_INVALID_CREDENTIAL":
          _error = AuthError.ERROR_INVALID_CREDENTIAL;
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
        case "ERROR_OPERATION_NOT_ALLOWED":
          _error = AuthError.ERROR_OPERATION_NOT_ALLOWED;
          break;
        case "ERROR_REQUIRES_RECENT_LOGIN":
        _error = AuthError.ERROR_REQUIRES_RECENT_LOGIN;
        break;
        default:
          _error = AuthError.ERROR_UNKNOWN;
          break;
      }
      return false;
    }
  }  
  Future<void> updateLastName(String last) async {
    await _dbRef.child("users/${user.uid}/lastName").set(last);
  }

  //Havent test out yet
  Future<void> deleteUser() async {

    //Delete user from the real time database
    await _dbRef.child("users/${user.uid}").remove().then((value) => {
      print("User deleted")
    }).catchError((e) {
      print("Error deleting user from realtime DB: " + e.toString());
    });

    await signOut();

    //Delete from auth
    await user.delete().then((value) => {
      print("User deleted")
    }).catchError((e) {
      print("Error deleting user from Firebase Auth: " + e.toString());
    });

  }

  Future<void> signOut() async {
    await _auth.signOut();
    print("Signout");
    await _googleSignIn.signOut();
    await _facebookLogin.logOut();
    _getCurrentUser();
    notifyListeners();
  }

} 