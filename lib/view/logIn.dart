import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view/signUp.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:webookapp/view/navbar.dart';

class LogInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                // Logo 
                Hero(
                  tag:'hero',
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                    child:Image.asset('assets/logo_transparent.png', height :250,width: 250),
                    ),
                ),
                //Email Textinput
                Padding(
                  padding:  const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Email',
                        icon: new Icon(
                          Icons.mail,
                          color: Colors.grey,
                    )),
                  validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                  ),
                ),
                //Password Textinput
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    controller: passwordController,
                    obscureText: true,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText: 'Password',
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.grey,
                        )),
                    validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                  ),
                ),
                // Login Button
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: new Text('Login',
                          style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                      onPressed: (){
                        auth.signInWithEmail(email:emailController.text, password: passwordController.text).whenComplete(() => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BottomNavBar())
                            )
                        })
                        .catchError((e) {
                          print(e.message);
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LogInPage())
                          );
                        });
                      },
                    ),
                  )
                ),
                // Login with Google Button
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 30, 0.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    child: new SignInButton(
                      Buttons.Google,
                      onPressed: (){
                        auth.signInWithGoogle().whenComplete(() => {
                                            Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => BottomNavBar())
                                            )
                        }).catchError((e) {
                          print(e.message);
                        });
                      }
                    )
                  )
                ),
                // Login with Facebook Button
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    child: new SignInButton(
                      Buttons.Facebook,
                      onPressed: (){}
                    )
                  )
                ),
                // Create New Acc button
                FlatButton(
                  child: new Text(
                      'Create an account' ,
                      style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
                  onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage())
                    );
                  }
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}