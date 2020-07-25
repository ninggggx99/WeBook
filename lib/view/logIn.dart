import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/widget/custom_SubmitButton.dart';
import 'package:webookapp/widget/custom_text.dart';

class LogInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AuthProvider auth;
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = Provider.of<AuthProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return Scaffold(
      body: Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  // Logo
                  Hero(
                    tag: 'hero',
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: Image.asset('assets/logo_transparent.png',
                          height: 220, width: 220),
                    ),
                  ),
                  //Email Textinput
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: new InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      const Color(0x009688).withOpacity(0.8))),
                          hintText: 'Email',
                          icon: new Icon(
                            Icons.mail,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'Email can\'t be empty' : null,
                    ),
                  ),
                  //Password Textinput
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      controller: passwordController,
                      obscureText: true,
                      autofocus: false,
                      decoration: new InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      const Color(0x009688).withOpacity(0.8))),
                          hintText: 'Password',
                          icon: new Icon(
                            Icons.lock,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'Password can\'t be empty' : null,
                    ),
                  ),
                  // Login Button
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical:25),
                        width: double.infinity,
                        child: CustomSubmitButton(text: "Login", action: onLoginPressed)
                      )),
                  Column(
                    children: <Widget>[
                      CustomText(
                        text: '- OR -',
                        colors: Colors.black,
                        size: 14,
                        weight: FontWeight.w400,
                      ),
                      SizedBox(height: 20.0),
                      CustomText(
                        text: 'Sign in with',
                        colors: Colors.black,
                        size: 14,
                        weight: FontWeight.normal,
                      ),
                    ],
                  ),
                  // Login with Google Button
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildGoogleSignIn(),
                          _buildFbSignIn()
                        ],
                      )),
                  SizedBox(height: 20.0),
                  FlatButton(
                      child: new Text('Don\'t have an account? Sign up',
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w300)),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signUp');
                      }),
                ],
              ),
            ))
      ],
    ));
  }

  Widget _buildGoogleSignIn() {
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return GestureDetector(
      onTap: () {
        login() async {
          await pr.show();
          bool result = await auth.signInWithGoogle();
          if (result == true) {
            print("Login success");
            await pr.hide();
            Navigator.pushReplacementNamed(context, '/mainHome');
            _formKey.currentState.reset();
          }
        }

        login();
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 2), blurRadius: 6.0)
            ],
            image: DecorationImage(
              image: AssetImage('assets/google.jpg'),
            )),
      ),
    );
  }

  Widget _buildFbSignIn() {
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return GestureDetector(
      onTap: () {
        logIn() async {
          await pr.show();
          bool result = await auth.signInWithFB();
          if (result == true) {
            print("Login success");
            await pr.hide();
            Navigator.pushReplacementNamed(context, '/mainHome');
          } else {
            print("log in with facebook failed!");
            await pr.hide();
            Navigator.pushReplacementNamed(context, '/logIn');
          }
        }

        logIn();
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 2), blurRadius: 6.0)
            ],
            image: DecorationImage(
              image: AssetImage('assets/facebook.png'),
            )),
      ),
    );
  }
  void onLoginPressed () async{
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    if (_formKey.currentState.validate()) {
      await pr.show();
      AuthResult result = await auth.signInWithEmail(
          email: emailController.text,
          password: passwordController.text);
      if (result != null) {
        print("Login success");
     
        await auth.saveFcmToken(result.user.uid, await _getDeviceToken());
        await pr.hide();
        Navigator.pushReplacementNamed(
            context, '/mainHome');
        emailController.clear();
        passwordController.clear();
      } else {
        AlertDialog alert = AlertDialog(
          title: Text("Error"),
          content: Text(getErrorMessage(auth.error)),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                _formKey.currentState.reset();
                emailController.clear();
                passwordController.clear();
                Navigator.of(context).pop();
              },
            )
          ],
        );
        await pr.hide();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            });
      }
    }
  }
   Future<String> _getDeviceToken() async {
    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    print(fcmToken);
    return fcmToken;

  }
  String getErrorMessage(AuthError errorcode) {
    // String error = " ";
    print(errorcode.toString() + "ERROR");
    switch (errorcode) {
      case AuthError.ERROR_INVALID_EMAIL:
        return "Incorrect Email/Password";
        break;
      case AuthError.ERROR_WRONG_PASSWORD:
        return "Incorrect Email/Password";
        break;
      case AuthError.ERROR_USER_NOT_FOUND:
        print("user not found");
        return "User not found ";
        break;
      case AuthError.ERROR_USER_DISABLED:
      case AuthError.ERROR_TOO_MANY_REQUESTS:
      case AuthError.ERROR_OPERATION_NOT_ALLOWED:
        return "Internal Error";
        break;
      case AuthError.ERROR_UNKNOWN:
        if (emailController.text == "" || passwordController.text == "") {
          return "Email/Password cannot be blank";
        }
        return "Unknown Error";
        break;
      default:
        return "Unknown Error";
        break;
    }
  }
}

