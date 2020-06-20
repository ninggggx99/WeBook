import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webookapp/model/comment_model.dart';
import 'package:webookapp/model/rating_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/widget/custom_starDisplay.dart';

class custom_feedbackContainer extends StatelessWidget{
  const custom_feedbackContainer({
    Key key,
    @required this.comment,
    // @required this.rating,
    @required this.date,
    @required this.user
  }) :super (key:key);
  final Comment comment;
  // final Rating rating;
  final String date;
  final User user;

  @override
  Widget build (BuildContext context){
   
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
               ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                   'https://wallpaperaccess.com/thumb/2056278.jpg',
                    height: 71,
                    width: 71,
                  ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.firstName,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:Colors.black
                      ),
                    ),
                            
                  ],
                )
              )
            ],
          ),
          SizedBox(height:5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(  
                children: <Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: Colors.amber,
                      size: 20
                    ),
                    child: custom_starDisplay(value: 3),
                  ), 
                  SizedBox(width : 5),
                  Text(
                    date,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:Colors.black
                    ),
                  )
                ],

              ), 
              Text(
                comment.commentDesc,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:Colors.grey
                ),
              ),  
            ],
          )
        ],
      ),
    );
  }
}