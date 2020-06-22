import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:webookapp/model/bookRecord_model.dart';
import 'package:webookapp/model/book_model.dart';

class LibraryProvider {

  FirebaseStorage _storage;
  DatabaseReference _dbRef;

  LibraryProvider() {
    _storage = FirebaseStorage(storageBucket: "gs://webook-a430e.appspot.com");
    _dbRef = FirebaseDatabase.instance.reference();
  }

  Future<List<Book>> getBooks(String uid) async {

    List<Book> books = [];
    List<BookRecord> records = [];

    try{
      
      DataSnapshot snapshot =  await _dbRef.child("bookRecords").once();
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        if (value["userId"] == uid) {
          records.add(BookRecord.fromJson(Map.from(value)));
        }
      });
      print('Successfully get Records');

      for (BookRecord record in records) {
      await _dbRef.child("books/${record.bookId}").once().then((DataSnapshot snapshot) {
        books.add(Book.fromSnapShot(snapshot));
        });
      }

      print('Successfully get book');
      
      //Sort by Recency
      Comparator<Book> dateComparator = (a, b) => b.dateCreated.compareTo(a.dateCreated);
      books.sort(dateComparator);

      return books;
    }catch(e){
      print ("NO BOOK");
      return null;
    }
    
    //Collecting all the book records
    // await _dbRef.child("bookRecords").once().then((DataSnapshot snapshot) {
    //   Map<dynamic, dynamic> values = snapshot.value;
    //   values.forEach((key, value) {
    //     if (value["userId"] == uid) {
    //       records.add(BookRecord.fromJson(Map.from(value)));
    //     }
    //   });
    // });

    // print('Successfully get Records');
    //Adding all the books
    // for (BookRecord record in records) {
    //   await _dbRef.child("books/${record.bookId}").once().then((DataSnapshot snapshot) {
    //     books.add(Book.fromSnapShot(snapshot));
    //   });
    // }

    // print('Successfully get book');
    // return books;
  }

  //Add Book into the library
  Future<bool> addBook(String bookId, String uid) async {

    bool exist = false;

    //Checking if it exist in the library akready
    await _dbRef.child("bookRecords").orderByChild("bookId").equalTo(bookId).once().then((DataSnapshot snapshot) { 
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          if (value["userId"] == uid) {
            exist = true;
          }
        });
      } else {
        exist = false;
      }
    }).catchError((e) {
      print("Error with finding if book exist alread in RTDB " + e.toString());
    });

    if (!exist) {

      BookRecord record = new BookRecord(bookId, uid, new DateTime.now());
      String key =  _dbRef.child("bookRecords").push().key;

      await _dbRef.child("bookRecords/$key").set(record.toJson()).catchError((e) {
        print("Error adding the bookRecord to the RTDB " + e.toString());
      });
    }

    return exist;
  }

  //Deleting book from library
  Future<bool> deleteBook(String bookId, String uid) async {
    
    bool deleted = false;

    //Search for the revord
    await _dbRef.child("bookRecords").orderByChild("userId").equalTo(uid).once().then((DataSnapshot snapshot) async { 
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          if (value["bookId"] == bookId) {
            
             _dbRef.child("bookRecords/$key").remove();
            deleted = true;
          }
        });
      } else {
        deleted = false;
      }
    }).catchError((e) {
      print("Error with deleting the book from RTDB " + e.toString());
    });

    return deleted;

  }

}