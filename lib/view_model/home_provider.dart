
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

    }).catchError((e) {
      print("Error with retrieving a book from RTDB " + e.toString());
    });

    return book;
  }

  Future<void> addComment(String bookID, String userId, String desc, int rate) async {

    Comment comment = new Comment(userId, desc, rate, new DateTime.now());
    String key = _dbRef.child("books/$bookID/comments").push().key;
    await _dbRef.child("books/$bookID/comments/$key").set(comment.toJson()).catchError((e) {
      print("Error with adding comment to RTDB " + e.toString());
    });

  }

  /*Future<void> addRating(String bookID, String userId, double rating) async {
    
    Rating rate = new Rating(userId, rating);
    String key = _dbRef.child("books/$bookID/ratings").push().key;
    await _dbRef.child("books/$bookID/ratings/$key").set(rate.toJson());

  }*/

  Future<List<Book>> getBooks(String id) async {
   
    DataSnapshot snapshot = await _dbRef.child("books").once()
                                .catchError((e) { 
                                  print("Error getting Books from RTDB for home " + e.toString());
                                });

    BookFeed _bookFeed = BookFeed.fromSnapshot(snapshot, id);
    
    //Sort by Record = No. of people reading
    //List<Book> sorted = await sortByRecord(_bookFeed.books);

    //Sort by Rating 
    //List<Book> sorted = _bookFeed.sortByRatings();

    //Sort by Date
    List<Book> sorted = _bookFeed.sortByRecent();

    return sorted;
 
  }

  Future<List<Comment>> getComments(Book book) async {

    List<Comment> comments = [];
    
    await _dbRef.child("books/${book.key}").orderByChild("dateCreated").once().then((DataSnapshot snapshot) {
      
      if (Book.fromSnapShot(snapshot).comments != null) {
        
        comments = Book.fromSnapShot(snapshot).comments;
        Comparator<Comment> dateComparator = (a, b) => b.dateCreated.compareTo(a.dateCreated);
        comments.sort(dateComparator);
      }
 
    }).catchError((e) {
      print("Error getting comments from realtime DB " + e.toString());
    });

    return comments;
  }

  Future<List<Book>> sortByRecord(List<Book> books) async {

    List<Book> sorted = books;
    
    for (Book book in sorted) {
      book.setReaders(await checkNoOfReaders(book));
    }

    Comparator<Book> readersComparator = (a, b) => b.readers.compareTo(a.readers);
    sorted.sort(readersComparator);
    return sorted;

  }


  Future<int> checkNoOfReaders(Book book) async {
    
    int no = 0;

    await _dbRef.child("bookRecords").orderByChild("bookId").equalTo(book.key).once().then((DataSnapshot snapshot) {
      if(snapshot.value != null) {
        Map<String, dynamic> maps = Map.from(snapshot.value);
        maps.forEach((key, value) {
          no++;
        });
      }
      
    }).catchError((e) {
      print("Error with checking for number of readers for a book " + e.toString());
    });

    return no;
  }



}

