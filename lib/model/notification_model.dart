import 'package:flutter/material.dart';



class Message{
  final String title;
  final String body;
  final String userId;
  final String commentId;
  final DateTime dateTime;  
  
  const Message({
    @required this.title,
    @required this.body,
    @required this.dateTime,
    @required this.userId,
    @required this.commentId
  });
}