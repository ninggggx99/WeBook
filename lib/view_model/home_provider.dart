
import 'package:firebase_database/firebase_database.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/bookFeed_model.dart';
import 'package:webookapp/model/comment_model.dart';
import 'package:webookapp/model/rating_model.dart';

class HomeProvider {

  DatabaseReference _dbRef;

  HomeProvider() {
    _dbRef = FirebaseDatabase.instance.reference();
  }

  Future<Book> retrieveBook(String bookID) async {
   
    Book book;
    await _dbRef.child("books/$bookID").once().then((DataSnapshot snapshot) {
      book = Book.fromJson(new Map<String, dynamic>.from(snapshot.value));
      print(book.comments);
    });

    return book;
  }

  Future<void> addComment(String bookID, String userId, String desc) async {

    Comment comment = new Comment(userId, desc, new DateTime.now());
    String key = _dbRef.child("books/$bookID/comments").push().key;
    await _dbRef.child("books/$bookID/comments/$key").set(comment.toJson());

  }

  Future<void> addRating(String bookID, String userId, double rating) async {
    
    Rating rate = new Rating(userId, rating);
    String key = _dbRef.child("books/$bookID/ratings").push().key;
    await _dbRef.child("books/$bookID/ratings/$key").set(rate.toJson());

  }

  Future<List<Book>> getBooks() async {
   
    DataSnapshot snapshot = await _dbRef.child("books").once();
    BookFeed _bookFeed = BookFeed.fromSnapshot(snapshot);
    return _bookFeed.books;
 
  }

  Future<List<Comment>> getComments(Book book) async {

    List<Comment> comments;
    await _dbRef.child("books/${book.key}").once().then((DataSnapshot snapshot) {
      comments = Book.fromSnapShot(snapshot).comments;
      print(comments);
    });
    return comments;
  }

}

