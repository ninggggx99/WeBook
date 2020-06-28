
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/file_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:flutter/foundation.dart';
import 'package:webookapp/widget/custom_text.dart';

class CreateBookPage extends StatefulWidget{
  CreateBookPage({Key key}) : super(key:key);
  @override
  _CreateBookPageState createState(){
      return _CreateBookPageState();
  }
}
class _CreateBookPageState extends State<CreateBookPage>{
  AuthProvider auth;
  FileProvider file;
  User user;

  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = Provider.of<AuthProvider>(context);  
    file = Provider.of<FileProvider>(context);
   
  }
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController catController = TextEditingController();
  TextEditingController coverController = TextEditingController();
  TextEditingController bookController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  //Can add more
  List<String> category = <String>[
    "Romance",
    "Thriller",
    "Fantasy",
    "Poetry",
    "Horror",
    "Action and Adventure",
    "Detective and Mystery",
    "Sci-Fi", 
    "Short Story"
  ];

  String selectedCat = "Romance";
  @override
  Widget build (BuildContext context){
    final pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    return Scaffold(
      body: Container(
        child: ListView(
          physics:  BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 25, top:25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Create Book',
                    style: GoogleFonts.openSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                    ),

                  )
                ],
              )
            ),
            Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        TextFormField(
                          controller: titleController,                  
                          maxLength: 25,                          
                          decoration: InputDecoration(
                            hintText: 'Title',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:const Color(0x009688).withOpacity(0.8))
                            ),
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
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color:const Color(0x009688).withOpacity(0.8))
                            ),
                            icon: new Icon(
                              Icons.description,
                              color: Colors.grey
                            )
                          ),
                          validator: (value) => value.isEmpty ? 'Book Description can\'t be empty' : null,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                              children: <Widget> [
                                Icon(Icons.category, color: Colors.grey),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                                  child: new DropdownButton<String> (
                                    icon: Icon(Icons.arrow_downward),
                                    hint: Text("Select your category"),
                                    value: selectedCat,
                                    iconSize: 24,
                                    elevation: 16,
                                    focusColor: const Color(0x009688).withOpacity(0.8),
                                    items: category.map((category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: new Text(category));
                                    },
                                    ).toList(),
                                    onChanged: (String value) {
                                      setState(() {
                                        selectedCat = value;
                                        catController.text = value;
                                      });
                                    },
                                  ),
                                )
                              ]
                            )
                        ),
                        //Upload Image
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,10,0,0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: CustomText(
                                    text: 'Book Cover', 
                                    size: 14, 
                                    weight: FontWeight.w400, 
                                    colors: Colors.black
                                ),
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
                                  child: CustomText(
                                    text: 'Upload Image', 
                                    size: 13.5, 
                                    weight: FontWeight.w600, 
                                    colors: Colors.black
                                  ),
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
                                child: CustomText(
                                  text: 'eBook (.epub)', 
                                  size: 14, 
                                  weight: FontWeight.w400, 
                                  colors: Colors.black                                  
                                )
                              ),
                              Expanded(
                                child: TextFormField(
                                  style: new TextStyle(
                                    fontSize: 12,
                                  ),
                                  controller: bookController,
                                  enabled: false,
                                  validator: (value) => value.isEmpty ? 'A document must be uploaded': null,
                                  )
                              ),
                              Expanded(
                                child: new RaisedButton(
                                  child: CustomText(
                                    text: 'Upload Book', 
                                    size: 14, 
                                    weight: FontWeight.w600, 
                                    colors: Colors.black
                                  ),
                                  onPressed: () {
                                    openFileExplorer() async {
                                      try {
                                        bookController.text = await FilePicker.getFilePath(type: FileType.custom, allowedExtensions: ['.epub+zip']);
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
                          padding: const EdgeInsets.fromLTRB(100, 30.0, 100, 30),
                          child: new RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            color: const Color(0x009688).withOpacity(0.8),
                            child: new Text(
                              "Upload My Work",
                              style:  GoogleFonts.openSans(
                                fontSize: 16,
                                color: Colors.white
                              )
                            ),
                            onPressed: () {
                              upload () async {
                                if(_formKey.currentState.validate()){
                                  await pr.show();
                                  User user = await auth.retrieveUser(); 

                                  await file.uploadBook(
                                    user, 
                                    titleController.text, 
                                    descController.text, 
                                    catController.text,
                                    coverController.text, 
                                    bookController.text);

                                  final snackBar = SnackBar(
                                    content: Text('Yay! Your work has been uploaded!'),
                                    duration: Duration(seconds: 3),);

                                  await pr.hide();

                                  titleController.clear();
                                  descController.clear();
                                  coverController.clear();
                                  bookController.clear();
                                  Scaffold.of(context).showSnackBar(snackBar);

                                  print("Submitted");
                                } else {
                                  print("Not Submitted");
                                }
                              }
                              upload();
                            },
                          )
                        ),
                      ],
                    )
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}