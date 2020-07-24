package com.example.webookapp;
import java.sql.Timestamp;
public class MessageNoti{
    public String title;
    public String body;
    public String userId;
    public String commentId;
    public String dateTime;
    public String bookId;

    public MessageNoti(){

    }
    public MessageNoti(String title, String body, String userId, String commentId, String dateTime, String bookId){
        this.title = title;
        this.body = body;
        this.userId = userId;
        this.commentId = commentId;
        this.dateTime = dateTime;
        this.bookId = bookId;
    }
}