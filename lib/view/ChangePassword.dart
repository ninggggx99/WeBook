
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() {
    return _ChangePasswordScreenState();
  }
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();

  User _user;
  AuthProvider _auth;

  void didChangeDependencies() {
    super.didChangeDependencies();
    _auth = Provider.of<AuthProvider>(context);
    load();
  }

  void load() async {
    final user = await _auth.retrieveUser();
    setState(() {
      _user = user;
      if (_user.profilePic == null){
        _user.profilePic = "https://i.pinimg.com/originals/c7/2c/a6/c72ca6b569e9729191b465dba7dda209.png";
      }
    });
  }

 
  @override
  Widget build(BuildContext context) {
    final pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
  
   return Scaffold(
    appBar: AppBar(),
    body: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key:_formKey,       
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding:  const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: new TextFormField(
                    obscureText: true,
                    maxLines: 1,
                    controller: oldPasswordController,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText:'Old Password',
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.grey,
                        )
                    ),
                  validator: (value) => value.isEmpty ? 'Old password can\'t be empty' : null,
                  ),
                ),
                Padding(
                  padding:  const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: new TextFormField(
                    obscureText: true,
                    maxLines: 1,
                    controller: newPasswordController,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText:'New Password',
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.grey,
                    )
                    ),
                  validator: (value) => value.isEmpty ? 'New password can\'t be empty' : null,
                  ),
                ),
              Padding(
                  padding:  const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: new TextFormField(
                    obscureText: true,
                    maxLines: 1,
                    controller: conPasswordController,
                    autofocus: false,
                    decoration: new InputDecoration(
                        hintText:'Confirm Password',
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.grey,
                    )
                    ),
                  validator: (value) => value.isEmpty ? 'Confirm password can\'t be empty' : null,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:15),
                  child: FlatButton(
                    onPressed: (){
                      editSave() async{
                        await pr.show();
                        print(conPasswordController.text);
                        if(_formKey.currentState.validate()){
                          if (newPasswordController.text == conPasswordController.text){
                            await _auth.updatePassword(oldPasswordController.text, newPasswordController.text);
                            oldPasswordController.clear();
                            newPasswordController.clear();
                            conPasswordController.clear();
                          }
                          else{
                            
                          }
                        }
                        else{
                          print("Not Submitted");
                        }
                        
                        await pr.hide();
                        Navigator.pop(context); 
                      
                        
                      }                           
                      editSave();          
                                
                    } ,
                      child: Text("Save changes"),
                  ),
                )
                
              ],

            )
            
          ),
        )
      ],
    ),
  );
 }
}
