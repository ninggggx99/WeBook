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
    
    //Collecting all the book records
    await _dbRef.child("bookRecords").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        if (value["userId"] == uid) {
          records.add(BookRecord.fromJson(Map.from(value)));
        }
      });
    });

    print('Successfully get Records');
    //Adding all the books
    for (BookRecord record in records) {
      await _dbRef.child("books/${record.bookId}").once().then((DataSnapshot snapshot) {
        books.add(Book.fromSnapShot(snapshot));
      });
    }

    print('Successfully get book');
    return books;
  }

  //Add Book into the library
  Future<void> addBook(String bookId, String uid) async {

    BookRecord record = new BookRecord(bookId, uid, false);
    String key =  _dbRef.child("bookRecords").push().key;

    await _dbRef.child("bookRecords/$key").set(record.toJson());

  }

  //Add the checking of whether the book is inside the library alr

}