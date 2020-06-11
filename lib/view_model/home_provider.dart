
import 'package:firebase_database/firebase_database.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/bookFeed_model.dart';


class HomeProvider {

  DatabaseReference _dbRef;

  HomeProvider() {
    _dbRef = FirebaseDatabase.instance.reference();
  }

  Future<Book> retrieveBook(String bookID) async {
    Book book;
    await _dbRef.child("books/$bookID").once().then((DataSnapshot snapshot) {
      book = Book.fromSnapShot(snapshot);
    });

    return book;
  }

  /*Future<Book> addComment(String bookID, User user, String desc) async {
    Comment comment = new Comment()
    await _dbRef.child("books/$bookID/comments").set(comment.toJson);
  }*/

  Future<List<Book>> getBooks() async {
   
    DataSnapshot snapshot = await _dbRef.child("books").once();
    BookFeed _bookFeed = BookFeed.fromSnapshot(snapshot);
    return _bookFeed.books;
 
  }

}

