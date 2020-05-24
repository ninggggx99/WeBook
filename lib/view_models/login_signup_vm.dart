import 'package:flutter/cupertino.dart';
import 'package:webookapp/database/authentication.dart';


class LogInSignUpViewModel {
  
  String userId;
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _role;
  String get role => _role;

  final BaseAuth auth;
  LogInSignUpViewModel({@required this.auth});

  Future<void> logIn() async {
    String userId = await auth.signIn(_email, _password);
    this.userId = userId;
  }

  Future<void> signUp() async {
    this.userId = await auth.signUp(_firstName, _lastName, _email, _password, _role);  
  }

  void setFirstName(String value) {
    _firstName = value;
  }

  void setLastName(String value) {
    _lastName = value;
  }

  void setEmail(String value) {
    _email = value;
  }

  void setPassword(String value) {
    _password = value;
  }
  
  void setRole(String value) {
    _role = value;
  }
  
}