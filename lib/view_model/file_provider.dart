import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';

class FileProvider {
  
  FirebaseStorage _storage;
  DatabaseReference _dbRef;

  FileProvider() {
    _storage = FirebaseStorage(storageBucket: "gs://webook-a430e.appspot.com");
    _dbRef = FirebaseDatabase.instance.reference();

  }
  Future<void> uploadBook(User user, String title, String desc, String category, String coverFilePath, String bookFilePath) async {

    String key =  _dbRef.child("books").push().key;
    String coverURL = await uploadDocument(user.key, key, title, coverFilePath, true);
    String bookURL = await uploadDocument(user.key, key, title, bookFilePath, false);
    String authorName = user.firstName + " " + user.lastName;
    Book book = new Book(title, desc, category, coverURL, [], [], user.key, authorName, bookURL);

    //Add the book to the database
    _dbRef.child("books").child(key).set(book.toJson());
    
  }

  //Upload cover or book
  Future<String> uploadDocument(String authID, String key, String title, String filePath, bool cover) async {

    String fileName = filePath.split('/').last;
    String _extension = fileName.split(".").last;
    StorageReference storageReference = _storage.ref().child("books");
    StorageUploadTask uploadTask;
    
    if (cover) {
      uploadTask = storageReference.child("$authID/$key/$title-cover").putFile(File(filePath), StorageMetadata(contentType: 'image/$_extension'));
    } else {
      uploadTask = storageReference.child("$authID/$key/$title-book").putFile(File(filePath), StorageMetadata(contentType: 'application/$_extension'));
    }
    
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();

    return url.toString();
  }

  Future<Book> retrieveBook(String bookID) async {
    Book book;
    await _dbRef.child("books/$bookID").once().then((DataSnapshot snapshot) {
      book = Book.fromSnapShot(snapshot);
    });

    return book;
  }

  //This can be used by both uploading and updating the profile pic
  Future<void> uploadProfilePic(User user, String filePath) async {

    String fileName = filePath.split('/').last;
    String _extension = fileName.split(".").last;
    StorageReference storageReference = _storage.ref().child("profile");
    //Uploading the image
    StorageUploadTask uploadTask = storageReference.child("${user.key}").putFile(File(filePath), StorageMetadata(contentType: 'image/$_extension'));
    
    //Getting the image url
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();

    await _dbRef.child("users/${user.key}").child("profilePic").set(url);
  }

  Future<File> createFileOfPdfUrl(String path) async {
    
    String url = path;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;

  }

}