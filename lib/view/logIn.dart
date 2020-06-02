import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LogInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key:_formKey,
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
                          login() async{
                            if(_formKey.currentState.validate()) {
                              bool result = await auth.signInWithEmail(email:emailController.text, password: passwordController.text);
                              if (result == true){
                                print("Login success");
                                Navigator.pushReplacementNamed(context, '/mainHome');
                                emailController.clear();
                                passwordController.clear();
                              }
                              else{
                                AlertDialog alert = AlertDialog(
                                  title: Text("Error"), 
                                  content: Text(getErrorMessage(auth.error)),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Ok"),
                                      onPressed: (){
                                        _formKey.currentState.reset();
                                        emailController.clear();
                                        passwordController.clear();
                                        Navigator.of(context).pop();
                                    
                                      },
                                      )
                                  ],
                                  );
                                showDialog(context: context, builder: (BuildContext context){return alert;});
                              }
                            }
                          }
                          login();
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
                        onPressed: () {
                          login() async{
                            bool result = await auth.signInWithGoogle();
                            if (result == true) {
                              print("Login success");
                              Navigator.pushReplacementNamed(context, '/mainHome');
                              this.dispose();
                            }
                          }
                          login();
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
                        onPressed: (){
                          logIn() async {
                            bool result = await auth.signInWithFB();
                            if(result == true) {
                              print("Login success");
                              Navigator.pushReplacementNamed(context, '/mainHome');
                            } else {
                              print("log in with facebook failed!");
                            }
                          }
                          logIn();
                        }
                      )
                    )
                  ),
                  // Create New Acc button
                  FlatButton(
                    child: new Text(
                        'Create an account' ,
                        style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
                    onPressed: (){
                        Navigator.pushReplacementNamed(context, '/signUp');
                    }
                  ),
                ],
              ),
            )
          )
        ],
      )
    );
  }

 String getErrorMessage(AuthError errorcode){
   
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
        return "Internal Error" ;
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