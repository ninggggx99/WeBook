import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view/logIn.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:webookapp/view/navbar.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = new GlobalKey<FormState>();
  
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailRegController = TextEditingController();
  TextEditingController passwordRegController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  List<String> roles = <String>[
    "Aspiring Writer",
    "Professional Writer",
    "Bookworm"
  ];

  String selectedRole = "Aspiring Writer";
  String selectedRoleGoogle = "Aspiring Writer";
  String selectedRoleFB = "Aspiring Writer";

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailRegController.dispose();
    passwordRegController.dispose();
    roleController.dispose();
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
                //First Name Textinput
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    controller: firstNameController,
                    autofocus: false,
                    decoration: new InputDecoration(
                    hintText: 'First Name',
                    icon: new Icon(
                      Icons.account_circle,
                      color: Colors.grey,
                    )),
                    validator: (value) => value.isEmpty ? 'First Name can\'t be empty' : null,
                  ),
                ),
                //Last Name Textinput
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    controller: lastNameController,
                    autofocus: false,
                    decoration: new InputDecoration(
                    hintText: 'Last Name',
                    icon: new Icon(
                      Icons.account_circle,
                      color: Colors.grey,
                    )),
                    validator: (value) => value.isEmpty ? 'Last Name can\'t be empty' : null,
                  ),
                ),
                //Email Textinput
                Padding(
                  padding:  const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: new TextFormField(
                    maxLines: 1,
                    controller: emailRegController,
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
                    controller: passwordRegController,
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
                //Role Dropdown
                Padding(
                  padding: const EdgeInsets.fromLTRB(35.0, 15.0, 0.0, 0.0),
                    child: new DropdownButton<String> (
                      icon: Icon(Icons.arrow_downward),
                      hint: Text("Select your role"),
                      value: selectedRole,
                      iconSize: 24,
                      elevation: 16,
                      items: roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: new Text(role));
                      },
                      ).toList(),
                      onChanged: (String value) {
                        setState(() {
                          selectedRole = value;
                          roleController.text = value;
                        });
                      },
                    ),
                  ),
                // Sign up Button
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: new Text('Sign Up',
                          style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                      onPressed: (){
                        signUp() async {
                          AuthResult result = await auth.createUser(firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          email:emailRegController.text, 
                                          password: passwordRegController.text,
                                          role: roleController.text);
                          if(result.user != null ) {
                            print("Sign Up");
                            Navigator.pushReplacementNamed(context, '/logIn');
                          } else {
                            print("Failed signUp");
                          }
    
                        }
                        signUp();
                      }
                    )
                  ),
                ),
                // Sign up with Google Button
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 30, 0.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    child: new SignInButton(
                      Buttons.Google,
                      text: "Sign up with Google",
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0)),
                                title: Text("What is your role?"),
                                content: Padding(
                                    padding: const EdgeInsets.fromLTRB(35.0, 15.0, 0.0, 0.0),
                                      child: new DropdownButton<String> (
                                        icon: Icon(Icons.arrow_downward),
                                        hint: Text("Select your role"),
                                        value: selectedRoleGoogle,
                                        iconSize: 24,
                                        elevation: 16,
                                        items: roles.map((role) {
                                          return DropdownMenuItem(
                                            value: role,
                                            child: new Text(role));
                                        },
                                        ).toList(),
                                        onChanged: (String value) {
                                          setState(() {
                                            selectedRoleGoogle = value;
                                            roleController.text = value;
                                          });
                                        },
                                      ),
                                    ) ,
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Sign Up'),
                                    onPressed: () {
                                      auth.signUpWithGoogle(roleController.text).whenComplete(() => {
                                          Navigator.of(context).pop(),
                                          Navigator.pushReplacementNamed(context, '/mainHome')
                                      }).catchError((e) {
                                        print("error with sign up with Google");
                                      });
                                    }
                                  ),
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }
                                  ,)
                                ],
                              );
                            });
                          }
                        ))
                ),
                // Sign up with Facebook Button
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
                  child: SizedBox(
                    height: 40.0,
                    child: new SignInButton(
                      Buttons.Facebook,
                      text: "Sign up with Facebook",
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0)),
                                title: Text("What is your role?"),
                                content: Padding(
                                    padding: const EdgeInsets.fromLTRB(35.0, 15.0, 0.0, 0.0),
                                      child: new DropdownButton<String> (
                                        icon: Icon(Icons.arrow_downward),
                                        hint: Text("Select your role"),
                                        value: selectedRoleFB,
                                        iconSize: 24,
                                        elevation: 16,
                                        items: roles.map((role) {
                                          return DropdownMenuItem(
                                            value: role,
                                            child: new Text(role));
                                        },
                                        ).toList(),
                                        onChanged: (String value) {
                                          setState(() {
                                            selectedRoleFB = value;
                                            roleController.text = value;
                                          });
                                        },
                                      ),
                                    ) ,
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Sign Up'),
                                    onPressed: () {
                                      auth.signUpWithFB(roleController.text).whenComplete(() => {
                                          Navigator.of(context).pop(),
                                          Navigator.pushReplacementNamed(context, '/mainHome')
                                      }).catchError((e) {
                                        print("error with sign up with FB");
                                      });
                                    }
                                  ),
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }
                                  ,)
                                ],
                              );
                            });
                          }
                    )
                  )
                ),
                // Create New Acc button
                FlatButton(
                  child: new Text(
                      'Have an account? Sign in' ,
                      style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
                  onPressed: (){
                    //_formKey.currentState.reset();
                    Navigator.pushReplacementNamed(context, '/logIn');
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