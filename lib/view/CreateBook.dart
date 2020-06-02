import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/fileUpload_provider.dart';

class CreateBookPage extends StatefulWidget{
  CreateBookPage({Key key}) : super(key:key);
  @override
  _CreateBookPageState createState(){
      return _CreateBookPageState();
  }
}
class _CreateBookPageState extends State<CreateBookPage>{

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController coverController = TextEditingController();
  TextEditingController bookController = TextEditingController();



  final _formKey = GlobalKey<FormState>();

  @override
  Widget build (BuildContext context){
    final auth = Provider.of<AuthProvider>(context);
    final fileUploader = Provider.of<FileUploadProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo_transparent.png'),
        backgroundColor: Colors.white,
        title: new Text(
                        "Create",
                        style: new TextStyle(
                          fontSize: 16,
                          color: Colors.black
                        )),
      ),
    
      body: Center(
        child: Form(
          key: _formKey,
          child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: new ListView(
                shrinkWrap: true,
                children: <Widget> [
                  TextFormField(
                    controller: titleController,
                    maxLength: 25,
                    decoration: new InputDecoration(
                      hintText: "Title",
                      icon: new Icon(
                        Icons.title,
                        color: Colors.grey
                      )
                    ),
                    validator: (value) => value.isEmpty ? 'Title can\'t be empty' : null,
                  ),
                  TextFormField(
                    controller: descController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: new InputDecoration(
                      hintText: "Book Description",
                      icon: new Icon(
                        Icons.description,
                        color: Colors.grey
                      )
                    ),
                    validator: (value) => value.isEmpty ? 'Book Description can\'t be empty' : null,
                  ),
                  //Upload Image
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,10,0,0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: new Text("Book Cover")
                        ),
                        Expanded(
                          child: new TextFormField(
                            style: new TextStyle(
                              fontSize: 12,
                            ),
                            controller: coverController,
                            enabled: false,
                          )
                        ),
                        Expanded(
                          child: new RaisedButton(
                            child: Text("Upload Image"),
                            onPressed: () {
                              openFileExplorer() async {
                                try {
                                  coverController.text = await FilePicker.getFilePath(type: FileType.image);
                                } on PlatformException catch (e) {
                                  print('Unsupported Operation ' + e.toString());
                                }

                              }
                              openFileExplorer();
                            }
                            )
                          )
                      ],
                    ),
                  ),
                  //Document Upload
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,10,0,0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: new Text("eBook")
                        ),
                        Expanded(
                          child: TextFormField(
                            style: new TextStyle(
                              fontSize: 12,
                            ),
                            controller: bookController,
                            enabled: false,
                            )
                        ),
                        Expanded(
                          child: new RaisedButton(
                            child: Text("Upload Book"),
                            onPressed: () {
                              openFileExplorer() async {
                                try {
                                  bookController.text = await FilePicker.getFilePath(type: FileType.any);
                                } on PlatformException catch (e) {
                                  print('Unsupported Operation ' + e.toString());
                                }
                              }
                              openFileExplorer();
                            }
                            )
                          )
                      ],
                    ),
                  ),
                  //Upload Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 30.0, 40, 30),
                    child: new RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: new Text(
                        "Upload My Work",
                        style: new TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        )),
                      onPressed: () {
                        upload () async {
                          if(_formKey.currentState.validate()){
                            User user = await auth.retrieveUser();
                            
                            await fileUploader.uploadBook(
                              user, 
                              titleController.text, 
                              descController.text, 
                              coverController.text, 
                              bookController.text);

                            print("Submitted");
                          } else {
                            print("Not Submitted");
                          }
                        }
                        upload();
                      },
                    )
                  ),

                ]
              )
            ),
          ],
        ),
      ),
      )
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}