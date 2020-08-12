import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:webookapp/widget/custom_text.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = new GlobalKey<FormState>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  

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
                      padding: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
                      child: Image.asset('assets/logo_transparent.png',
                          height: 250, width: 250),
                    ),
                  ),
                  //First Name Textinput
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      controller: firstNameController,
                      autofocus: false,
                      decoration: new InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      const Color(0x009688).withOpacity(0.8))),
                          hintText: 'First Name',
                          icon: new Icon(
                            Icons.account_circle,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'First Name can\'t be empty' : null,
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
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      const Color(0x009688).withOpacity(0.8))),
                          hintText: 'Last Name',
                          icon: new Icon(
                            Icons.account_circle,
                            color: Colors.grey,
                          )),
                      validator: (value) =>
                          value.isEmpty ? 'Last Name can\'t be empty' : null,
                    ),
                  ),
                  //Email Textinput
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      controller: emailRegController,
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
                    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      controller: passwordRegController,
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
                  //Role Dropdown
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.account_box,
                          color: Colors.grey,
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                            child: Row(children: <Widget>[
                              Text(
                                "Role : ",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 15),
                              ),
                              new DropdownButton<String>(
                                icon: Icon(Icons.arrow_downward),
                                hint: Text("Select your role"),
                                value: selectedRole,
                                iconSize: 24,
                                elevation: 16,
                                items: roles.map(
                                  (role) {
                                    return DropdownMenuItem(
                                        value: role, child: new Text(role));
                                  },
                                ).toList(),
                                onChanged: (String value) {
                                  setState(() {
                                    selectedRole = value;
                                    roleController.text = value;
                                  });
                                },
                              ),
                            ]))
                      ])),
                  // Sign up Button
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      width: double.infinity,
                      child: new RaisedButton(
                          elevation: 5.0,
                          padding: EdgeInsets.all(15.0),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: const Color(0x009688).withOpacity(0.8),
                          child: new Text('Sign Up',
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white)),
                          onPressed: () {
                            signUp() async {
                              if (_formKey.currentState.validate()) {
                                await pr.show();
                                String fcmToken = await _getDeviceToken();
                                AuthResult result = await auth.createUser(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    email: emailRegController.text,
                                    password: passwordRegController.text,
                                    role: roleController.text);
                                if (result.user != null) {
                                  print("Sign Up");
                                  await auth.saveFcmToken(result.user.uid, fcmToken);
                                  await pr.hide();
                                  Navigator.pushReplacementNamed(
                                      context, '/logIn');
                                } else {
                                  print("Failed signUp");
                                }
                              }
                            }

                            signUp();
                          }),
                    ),
                  ),
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
                        text: 'Sign up with',
                        colors: Colors.black,
                        size: 14,
                        weight: FontWeight.normal,
                      ),
                    ],
                  ),
                  // Sign up with Google Button
                  Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _buildGoogleSignUp(),
                          _buildFbSignUp()
                        ],
                      )),
                  // Create New Acc button
                  FlatButton(
                      child: new Text('Have an account? Sign in',
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w300)),
                      onPressed: () {
                        _formKey.currentState.reset();
                        Navigator.pushReplacementNamed(context, '/logIn');
                      }),
                ],
              ),
            ))
      ],
    ));
  }

  Widget _buildFbSignUp() {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Text("What is your role?"),
                content: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(children: <Widget>[
                      Icon(
                        Icons.account_box,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                        child: new DropdownButton<String>(
                          icon: Icon(Icons.arrow_downward),
                          hint: Text("Select your role"),
                          value: selectedRoleFB,
                          iconSize: 24,
                          elevation: 16,
                          items: roles.map(
                            (role) {
                              return DropdownMenuItem(
                                  value: role, child: new Text(role));
                            },
                          ).toList(),
                          onChanged: (String value) {
                            setState(() {
                              selectedRoleFB = value;
                              roleController.text = value;
                            });
                          },
                        ),
                      )
                    ])),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Sign Up'),
                      onPressed: () async{
                        String fcmToken = await _getDeviceToken();
                        auth
                            .signUpWithFB(roleController.text,fcmToken)
                            .whenComplete(() => {
                                  Navigator.of(context).pop(),
                                  Navigator.pushReplacementNamed(
                                      context, '/logIn')
                                })
                            .catchError((e) {
                          print("error with sign up with FB");
                        });
                      }),
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: Container(
        height: 60,
        width: 60,
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

  Widget _buildGoogleSignUp() {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                title: Text("What is your role?"),
                content: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(children: <Widget>[
                      Icon(
                        Icons.account_box,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                        child: new DropdownButton<String>(
                          icon: Icon(Icons.arrow_downward),
                          hint: Text("Select your role"),
                          value: selectedRoleGoogle,
                          iconSize: 24,
                          elevation: 16,
                          items: roles.map(
                            (role) {
                              return DropdownMenuItem(
                                  value: role, child: new Text(role));
                            },
                          ).toList(),
                          onChanged: (String value) {
                            setState(() {
                              selectedRoleGoogle = value;
                              roleController.text = value;
                            });
                          },
                        ),
                      )
                    ])),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Sign Up'),
                      onPressed: () async {
                        String fcmToken = await _getDeviceToken();
                        auth
                            .signUpWithGoogle(roleController.text,fcmToken)
                            .whenComplete(() => {
                                  Navigator.of(context).pop(),
                                  Navigator.pushReplacementNamed(
                                      context, '/logIn')
                                })
                            .catchError((e) {
                          print("error with sign up with Google");
                        });
                      }),
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      },
      child: Container(
        height: 60,
        width: 60,
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
   _getDeviceToken() async {
    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    print(fcmToken);

  }
}
