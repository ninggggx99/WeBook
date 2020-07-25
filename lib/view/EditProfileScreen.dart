import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/widget/custom_AppBar.dart';
import 'package:webookapp/widget/custom_loadingPage.dart';
import 'package:webookapp/widget/custom_text.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController usernameController = TextEditingController();
  String filename;

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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  FocusNode userFocus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    
    if (_user == null){
      return CustomLoadingPage();
    }
    else{
      usernameController.value = usernameController.value.copyWith(
      text: _user.firstName
      );
      print(_user.firstName);
      return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(text: "Edit Profile"),
        body: Container(
          child: Form(
            key:_formKey,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: new ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white60, width: 2.0),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: 
                              filename == null ?
                              (CircleAvatar(
                                backgroundImage: NetworkImage(_user.profilePic),
                              ))
                              :(CircleAvatar(
                                backgroundImage: ExactAssetImage(filename),
                              ))
                            ),
                            FlatButton(
                              onPressed: (){
                                  openFileExplorer() async {
                                    try {
                                      filename  = await FilePicker.getFilePath(type: FileType.image);
                                      // print(filename);
                                      setState(() {
                                        filename = filename;
                                      });

                                    } on PlatformException catch (e) {
                                      print('Unsupported Operation ' + e.toString());
                                    }
                                  }
                                  openFileExplorer();
                                } ,
                                child: CustomText(
                                  text: 'Change Profile Photo',
                                  size: 14,
                                  weight: FontWeight.normal ,
                                  colors: Colors.black,
                                ),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                          focusNode: userFocus,
                          decoration: InputDecoration(
                            
                            icon: Icon(
                              Icons.person,
                              color: Colors.grey
                            ),
                            labelText: 'Username *',
                            labelStyle: TextStyle(
                              color: userFocus.hasFocus? Color(0x009688).withOpacity(0.8) : Colors.grey
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:const Color(0x009688).withOpacity(0.8))
                            )
                          ),
                          style: new TextStyle(
                            fontSize: 15,
                          ),
                          controller: usernameController,
                          enabled: true,
                          validator: (value) => value.isEmpty ? 'Username cannot be empty': null,
                          
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(110,10,110,10),
                        child: 
                        FlatButton(
                          color: const Color(0x009688).withOpacity(0.6),
                          hoverColor: const Color(0x009688).withOpacity(0.8),
                          
                          onPressed: editSave,
                            child: CustomText(
                              text: 'Save Changes',
                              size: 14,
                              weight: FontWeight.w700 ,
                              colors: Colors.white,
                            ),
                        ),
                      )
                      
                    ],
          
                  )
                ),
              ],
            ),
          ),
        ),
      );

    }
   
  }
  void editSave () async {
    final pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    await pr.show();
    if(_formKey.currentState.validate()){
      if (filename == null){
        await _auth.updateFirstName(usernameController.text);
      }
      else{
        await _auth.updateFirstName(usernameController.text);
        await _auth.uploadProfilePic(_user, filename);  
      }
    }
    else{
      print("Not Submitted");
    }
    
    await pr.hide();
    Navigator.pop(context); 
  
  }
}
