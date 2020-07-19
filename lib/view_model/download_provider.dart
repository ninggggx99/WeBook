import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webookapp/model/bookRecord_model.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/utils/consts.dart';
import 'package:webookapp/widget/custom_downloadAlert.dart';

class DownloadProvider {

  DatabaseReference _dbRef;
  DownloadProvider(){
    _dbRef = FirebaseDatabase.instance.reference();
  }

  // get book rec id
  Future<String> getBookRecId (String bookId, String uid) async {
    String bookrecId;
    await _dbRef.child("bookRecords").orderByChild("userId").equalTo(uid).once().then((DataSnapshot snapshot) async{
      if (snapshot.value != null){
        Map<dynamic,dynamic> values = snapshot.value;
        values.forEach((key, value) {
          if (value["bookId"] == bookId){
            bookrecId = key;
            print("found");
          }
        });
      }
    });    
    return bookrecId;
  }
  Future <List<Book>> getDownloadedBooks (String uid) async{
    List <BookRecord> bookRecList = [];
    List <Book> bookList = [];

    try{
      await _dbRef.child("bookRecords").orderByChild("userId").equalTo(uid).once().then((DataSnapshot snapshot) async {
        Map<dynamic,dynamic> values = Map.from(snapshot.value);
        values.forEach((key, value) {
          BookRecord bookRec = BookRecord.fromJson(Map.from(value));
          if (bookRec.download == true){
            bookRecList.add(bookRec);
          }
        });
      });
      for(var i = 0; i < bookRecList.length; i++){
        Book book = await getBook(bookRecList[i].bookId);
        bookList.add(book);
      }
      print("booklist");
      print(bookList);
      return bookList;
    }
    catch(e){
      print("Error with retrieving user's downloaded books: " + e.toString());
      return bookList;
    }
  }
  Future<Book> getBook (String bookId) async {
    Book book;
    await _dbRef.child("books/$bookId").once().then((DataSnapshot snapshot) async {
      book = Book.fromSnapShot(snapshot);
     
    });
    return book;
  }
  Future<bool> checkBookDownload (String bookrecId) async{
    BookRecord bookRecord;
    await _dbRef.child("bookRecords/$bookrecId").once().then((DataSnapshot snapshot) async {
      bookRecord = BookRecord.fromSnapShot(snapshot);
    });

    if (bookRecord.download == true) {
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> updateBookDownload (String bookId, String uid) async{
    String bookrecId = await getBookRecId(bookId, uid);
    print(bookrecId);
    bool downloadExist = await checkBookDownload(bookrecId);
    // bool downloadExist = false;
    if (downloadExist == false){
      await _dbRef.child("bookRecords/$bookrecId/download").set(true);
    }    
  }
  
  Future<void> deleteBookDownload (String bookId, String uid) async{
    String bookrecId = await getBookRecId(bookId, uid);
    bool downloadExist = true;
    // bool downloadExist = await checkBookDownload(bookrecId);
    if (downloadExist == true){

      await _dbRef.child("bookRecords/$bookrecId/download").set(false);
    }    
  }
  Future<void> removeBook (String url, String filename, String bookId, String uid) async{
    String bookRecId = await getBookRecId(bookId, uid);
    bool bookDownload = await checkBookDownload(bookRecId);
    if (bookDownload == true){
      Directory appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : null;
      if (Platform.isAndroid){
        Directory(appDocDir.path.split('Android')[0] + '${Constants.appName}').createSync();
      }
      String path = appDocDir.path.split('Android')[0] + '${Constants.appName}/$filename.epub';
      print(path);

      File file = File(path);
      if (await file.exists()){
        await file.delete();
        await deleteBookDownload(bookId, uid);
      }    
    } 
    
  }

  Future<void> downloadBook (BuildContext context, String url, String filename, String bookId, String uid) async{
    Directory appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : null;
    if (Platform.isAndroid){
      Directory(appDocDir.path.split('Android')[0] + '${Constants.appName}').createSync();
    }
    String path = appDocDir.path.split('Android')[0] + '${Constants.appName}/$filename.epub';
    print(path);

    File file = File(path);
    if (!await file.exists()){
      await file.create();
    } else{
      await file.delete();
      await file.create();
    }
    
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DownloadAlert(
        url: url, 
        path: path
      )
    ).then((v) async{
      await updateBookDownload(bookId, uid);
    });
  }
}