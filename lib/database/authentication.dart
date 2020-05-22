import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:webookapp/models/user_model.dart';

abstract class BaseAuth {

  Future<String> signIn(String email, String password);

  Future<String> signUp(String firstName, String lastName, String email, String password, String role);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();

}

class Auth implements BaseAuth {
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

    User acc = User(firstName, lastName, email, password, role);
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

}


class AccountHelper {
  
  static DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("users");
  
  static Future<FirebaseUser> signUp(String firstName, String lastName, String email, String password, String role) async {
    
    try {
      FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user;
      
      User acc = User(firstName, lastName, email, password, role);
      dbRef.child(user.uid).set(acc.toJson());
    } catch (e) {
      print(e.message);
    }
  }

  static Future<User> signIn(String email, String password) async {
    
    FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user;
    dbRef.child(user.uid).once().then((DataSnapshot snapshot) {
      User acc = User.fromSnapShot(snapshot);
      return acc;
    });

  }

}