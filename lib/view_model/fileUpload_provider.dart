import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/user_model.dart';

class FileUploadProvider {
  
  FirebaseStorage _storage;
  DatabaseReference _dbRef;

  FileUploadProvider() {
    _storage = FirebaseStorage(storageBucket: "gs://webook-a430e.appspot.com");
    _dbRef = FirebaseDatabase.instance.reference();

  }

  Future<void> uploadBook(User user, String title, String desc, String coverFilePath, String bookFilePath) async {

    String key =  _dbRef.child("books").push().key;
    String coverURL = await uploadDocument(user.key, key, title, coverFilePath, true);
    String bookURL = await uploadDocument(user.key, key, title, bookFilePath, false);
    String authorName = user.firstName + " " + user.lastName;
    Book book = new Book(title, desc, coverURL,  0, user.key, authorName, bookURL);

    _dbRef.child("books").child(key).set(book.toJson());
    print("books");


  }


  Future<String> uploadDocument(String authID, String key, String title, String filePath, bool cover) async {

    String fileName = filePath.split('/').last;
    String _extension = fileName.split(".").last;
    StorageReference storageReference = _storage.ref().child("books");
    StorageUploadTask uploadTask;
    
    if (cover) {
      uploadTask = storageReference.child("$authID/$key/$title-cover").putFile(File(filePath), StorageMetadata(contentType: '$_extension'));
    } else {
      uploadTask = storageReference.child("$authID/$key/$title-book").putFile(File(filePath), StorageMetadata(contentType: '$_extension'));
    }
    
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();

    return url.toString();
  }

}