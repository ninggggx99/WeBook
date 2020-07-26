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

  Future<void> uploadBook(User user, String title, String desc, String category,
      String coverFilePath, String bookFilePath) async {
    String key = _dbRef.child("books").push().key;
    String coverURL =
        await uploadBookCover(user.key, key, coverFilePath);
    String bookURL = await uploadEPub(user.key, key, bookFilePath);
    String authorName = user.firstName + " " + user.lastName;
    Book book = new Book(title, desc, category, coverURL, [], user.key,
        authorName, bookURL, new DateTime.now());

    //Add the book to the database
    _dbRef.child("books").child(key).set(book.toJson());
  }

  //Uploading of Epub type of File
  Future<String> uploadEPub(
      String authID, String key, String filePath) async {
    StorageReference storageReference = _storage.ref().child("books");
    StorageUploadTask uploadTask;

    File file = new File(filePath);
  
    uploadTask = storageReference.child("$authID/$key/book").putFile(
        file, StorageMetadata(contentType: 'application/epub+zip'));

    var url = await (await uploadTask.onComplete).ref.getDownloadURL();

    return url.toString();
  }

    //Uploading of Image for Book Cover
  Future<String> uploadBookCover(
      String authID, String key, String filePath) async {
    String fileName = filePath.split('/').last;
    String _extension = fileName.split(".").last;

    StorageReference storageReference = _storage.ref().child("books");
    StorageUploadTask uploadTask = storageReference
        .child("$authID/$key/cover")
        .putFile(
            File(filePath), StorageMetadata(contentType: 'image/$_extension'));
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


  Future<void> updateBookEpub(Book book, String newFilePath) async {
    
    try {
        
        await _storage
          .ref()
          .child("books")
          .child(book.authorId)
          .child(book.key)
          .child("book")
          .delete();

    } catch (e) {
      print("Error with deleting epub:" + e.toString());
    }

    try {
      
      String bookURL = await uploadEPub(book.authorId, book.key, newFilePath);

        await _dbRef.child("books").child(book.key).child("bookURL").set(bookURL);
    } catch (e) {
      print("Error with updating epub:" + e.toString());
    }
  }

  Future<void> updateBookCover(Book book, String newPicPath) async {
    
    try {
      await _storage
          .ref()
          .child("books")
          .child(book.authorId)
          .child(book.key)
          .child("cover")
          .delete();

      /*await _storage
          .ref()
          .child(book.coverURL)
          .delete();*/

    } catch (e) {
      print("Error with deleting cover:" + e.toString());
    }

    try {
      String coverURL =
            await uploadBookCover(book.authorId, book.key, newPicPath);

        await _dbRef.child("books").child(book.key).child("coverURL").set(coverURL);
    } catch (e) {
      print("Error with updating cover:" + e.toString());
    }

  }

  //Uploading of any type of files except for EPUB and images (eg. PDF)
  /* Future<String> uploadDocument(String authID, String key, String title, String filePath) async {

    String fileName = filePath.split('/').last;
    String _extension = fileName.split(".").last;
    StorageReference storageReference = _storage.ref().child("books");
    StorageUploadTask uploadTask;
  
    uploadTask = storageReference.child("$authID/$key/$title-book").putFile(File(filePath), StorageMetadata(contentType: 'application/$_extension'));
      
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();

    return url.toString();
  } */


  //This can be used by both uploading and updating the profile pic
  Future<void> uploadProfilePic(User user, String filePath) async {
    String fileName = filePath.split('/').last;
    String _extension = fileName.split(".").last;
    StorageReference storageReference = _storage.ref().child("profile");
    //Uploading the image
    StorageUploadTask uploadTask = storageReference
        .child("${user.key}")
        .putFile(
            File(filePath), StorageMetadata(contentType: 'image/$_extension'));

    //Getting the image url
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();

    await _dbRef.child("users/${user.key}").child("profilePic").set(url);
  }

  Future<void> updateBookDetails(Book book, String title, String desc, String cat) async {
    try {
      await _dbRef.child("books/${book.key}").child("title").set(title);
      await _dbRef.child("books/${book.key}").child("description").set(desc);
      await _dbRef.child("books/${book.key}").child("category").set(cat);
    } catch (e) {
      print("Error with updating book details : " + e.toString());
    }
  }

  Future<void> deleteBookP(Book book) async {
    try {
      await _dbRef
          .child("notifications/${book.authorId}")
          .orderByChild("bookId")
          .equalTo(book.key)
          .once()
          .then((DataSnapshot snapshot) async {
            if (snapshot.value != null){
              Map<dynamic, dynamic> maps = Map.from(snapshot.value);
              print("MAP");
              print(maps);
              maps.forEach((key, value) async {
                print(book.key);
                print(key);
                if (value["bookId"] == book.key){
                  await _dbRef.child("notifications/${book.authorId}/$key").remove();
                }
              });
            }
        
      });
      print("done noti");
      //Delete from book records
      await _dbRef
          .child("bookRecords")
          .orderByChild("bookId")
          .equalTo(book.key)
          .once()
          .then((DataSnapshot snapshot) async {
            if (snapshot.value != null){
              print("here");
              Map<dynamic, dynamic> maps = Map.from(snapshot.value);
                maps.forEach((key, value) async {
                  await _dbRef.child("bookRecords/$key").remove();
              });
            }
       
      });
      //Delete from storage
      // await _storage
      //     .ref()
      //     .child("books")
      //     .child(book.authorId)
      //     .child(book.key)
      //     .delete();
      //Then call the epub func.

      //Delete from books
      await _dbRef.child("books/${book.key}").remove();

      

    } catch (e) {
      print("Error with deleting book permanently : " + e.toString());
    }
  }

  Future<File> convertFile(String path) async {
    String url = path;
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    //Test out more
    File file = new File('$dir/temp.epub');
    await file.writeAsBytes(bytes);
    return file;
  }

  /*Future<File> createFileOfPdfUrl(String path) async {
    
    String url = path;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;

  }*/

}
