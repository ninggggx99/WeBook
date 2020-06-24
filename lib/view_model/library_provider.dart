import 'package:firebase_database/firebase_database.dart';
import 'package:webookapp/model/bookRecord_model.dart';
import 'package:webookapp/model/book_model.dart';

class LibraryProvider {

  DatabaseReference _dbRef;

  LibraryProvider() {
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
        
        Comparator<Book> dateComparator = (a, b) => b.dateCreated.compareTo(a.dateCreated);
        books.sort(dateComparator);

      }

      print('Successfully get book');
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
    });

    if (!exist) {

      BookRecord record = new BookRecord(bookId, uid, false);
      String key =  _dbRef.child("bookRecords").push().key;

      await _dbRef.child("bookRecords/$key").set(record.toJson());
    }

    return exist;
  }

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
    });

    return deleted;

  }

}