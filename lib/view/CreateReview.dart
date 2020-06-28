
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/view_model/home_provider.dart';
import 'package:webookapp/widget/custom_text.dart';

class CreateReview extends StatefulWidget {
  @override
  _CreateReviewState createState() {
    return _CreateReviewState();
  }
  final Book bookModel;
  final AuthProvider _auth;
  final HomeProvider _home;

  CreateReview(this.bookModel,this._auth,this._home);
}

class _CreateReviewState extends State<CreateReview> {
  final _formKey = new GlobalKey<FormState>();

  TextEditingController commentDescController = TextEditingController();

  int _rate;
  double rating = 0;

 
  @override
  Widget build(BuildContext context) {
    final pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
  
   return Scaffold(
    appBar: AppBar(
       backgroundColor: Color(0x009688).withOpacity(0.5),
    ),
    body: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key:_formKey,       
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0.0),
                      child: CustomText(
                        size: 16,
                        colors: Colors.grey,
                        text: 'Rate us ',
                        weight: FontWeight.normal,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0.0),
                      child: SmoothStarRating(
                        color: const Color(0x009688).withOpacity(0.8) ,
                        borderColor: const Color(0x009688).withOpacity(0.8),
                        allowHalfRating: false,
                        starCount: 5,
                        rating: rating,
                        size: 20,
                        isReadOnly: false,
                        filledIconData: Icons.star,
                        defaultIconData: Icons.star_border,
                        spacing: 2,
                        onRated: (rate){
                          setState(() {
                            _rate = rate.toInt();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:  const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: new TextFormField(
                    obscureText: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: commentDescController,
                    autofocus: true,
                    decoration: new InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color:const Color(0x009688).withOpacity(0.8))
                      ),
                      hintText:'Write a Review!',
                      icon: new Icon(
                        Icons.rate_review,
                        color: Colors.grey,
                      )
                    ),
                  validator: (value) => value.isEmpty ? 'Review can\'t be empty' : null,
                  ),
                ),
              
                Padding(
                  padding:  EdgeInsets.fromLTRB(110,10,110,10),
                  child: FlatButton(
                    color: const Color(0x009688).withOpacity(0.6),
                    hoverColor: const Color(0x009688).withOpacity(0.8),
                    onPressed: (){
                      editSave() async{
                        
                        
                        if(_formKey.currentState.validate()){
                          await pr.show();
                        
                          await widget._home.addComment(widget.bookModel.key, widget._auth.user.uid, commentDescController.text, _rate);
                          // bool result = await _auth.(oldPasswordController.text, newPasswordController.text);
                          // oldPasswordController.clear();
                          // newPasswordController.clear();
                          // // conPasswordController.clear();
                          // print(result);
                          // if (result == true){
                          //   await pr.hide();
                          //   Navigator.pop(context); 
                          // }
                          // else{
                          //   AlertDialog alert = AlertDialog(
                          //     title: Text("Error"), 
                          //     // content: Text(getErrorMessage(_auth.error)),
                          //     actions: <Widget>[
                          //       FlatButton(
                          //         child: Text("Ok"),
                          //         onPressed: (){
                          //           _formKey.currentState.reset();
                          //           Navigator.of(context).pop();
                          //         },
                          //         )
                          //     ],
                          //   );
                          await pr.hide();
                          Navigator.pop(context);
                          //   showDialog(context: context, builder: (BuildContext context){return alert;});
                          // }
                         
                        }
                        else{
                          print("Not Submitted");
                        }                   
                        
                      }                           
                      editSave();          
                                
                    } ,
                      child: CustomText(
                        text: 'Add Review',
                        size: 14,
                        weight: FontWeight.w700 ,
                        colors: Colors.white,
                      ),
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

