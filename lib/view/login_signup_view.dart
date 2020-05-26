import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:webookapp/database/authentication.dart';
import 'package:webookapp/view_model/login_signup_vm.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  LogInSignUpViewModel vm;

  String _errorMessage;
  bool _isLoginForm;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    vm = LogInSignUpViewModel(auth: widget.auth);
  }

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      try {
        if (_isLoginForm) {
          vm.logIn();
          print('Signed in: $vm.userId');
        } else {
          vm.signUp();
          toggleFormMode();
          print('Signed up user: $vm.userId');
          
        }

        setState(() {
          _isLoading = false;
        });

        if (vm.userId.length > 0 && vm.userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            _showForm(),
            //Loading needs to be fixed
            //_showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _logInForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showGoogleSignInButton(),
              showFBSignInButton(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _signUpForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showFirstNameInput(),
              showLastNameInput(),
              showEmailInput(),
              showPasswordInput(),
              showRoleInput(),
              showGoogleSignUpButton(),
              showFBSignUpButton(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showForm() {
    return _isLoginForm ? _logInForm() : _signUpForm();
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: Image.asset('assets/logo_transparent.png', height: 250, width: 250),
      ),
    );
  }
  Widget showFirstNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'First Name',
            icon: new Icon(
              Icons.account_circle,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'First Name can\'t be empty' : null,
        onSaved: (value) => vm.setFirstName(value.trim()),
      ),
    );
  }

  Widget showLastNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Last Name',
            icon: new Icon(
              Icons.account_circle,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Last Name can\'t be empty' : null,
        onSaved: (value) => vm.setLastName(value.trim()),
      ),
    );
  }

     Widget showRoleInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35.0, 15.0, 0.0, 0.0),
      child: new DropdownButton<String> (
        icon: Icon(Icons.arrow_downward),
        value: "Aspiring Writer",
        iconSize: 24,
        elevation: 16,
        items: [
          DropdownMenuItem<String>(
            value: 'Aspiring Writer',
            child: Text('Aspiring Writer'),
          ),
          DropdownMenuItem<String>(
            value: 'Professional Writer',
            child: Text('Professional Writer')
          ),
          DropdownMenuItem<String>(
            value: 'Bookworm',
            child: Text('Bookworm')
          )
        ],
        onChanged: (value) => vm.setRole(value.trim())
      ),
      );
    }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => vm.setEmail(value.trim()),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => vm.setPassword(value.trim()),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }


    Widget showGoogleSignInButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new SignInButton(
            Buttons.Google, 
            onPressed: (){
              vm.signInGoogle().whenComplete(() => 
                widget.loginCallback()
              );
            })
        ));
    }

    Widget showFBSignInButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new SignInButton(
            Buttons.Facebook, 
            onPressed: (){})
        ));
    }

    Widget showGoogleSignUpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new SignInButton(
            Buttons.Google, 
            text: "Sign up with Google",
            onPressed: (){
              
              //vm.signInGoogle();
              vm.signInGoogle().whenComplete(() => {
                _showDialog(context)
              }
              );
              }
        ))
        );
    }

    Widget showFBSignUpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new SignInButton(
            Buttons.Facebook, 
            text: "Sign up with Facebook",
            onPressed: (){})
        ));
    }

  _showDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("What is your role?"),
        content: showRoleInput(),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Back"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            onPressed: () {
              vm.addUser().whenComplete(() => {
                  Navigator.of(context).pop(),
                  widget.loginCallback()
              }
              );
            }, 
            child: new Text("Submit")
          )
        ],
      );
    });
    }
  }
  
