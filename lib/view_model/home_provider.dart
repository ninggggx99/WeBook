import 'package:firebase_database/firebase_database.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/bookFeed_model.dart';
import 'package:webookapp/model/comment_model.dart';

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

  Future<void> addComment(
      String bookID, String userId, String desc, int rate) async {
    Comment comment = new Comment(userId, desc, rate, new DateTime.now());
    String key = _dbRef.child("books/$bookID/comments").push().key;
    await _dbRef
        .child("books/$bookID/comments/$key")
        .set(comment.toJson())
        .catchError((e) {
      print("Error with adding comment to RTDB " + e.toString());
    });
  }

  Future<void> editComment(
      String bookID, Comment comment, String desc, int rate) async {
    try {
      await _dbRef
          .child("books/$bookID/comments/${comment.key}")
          .child("commentDesc")
          .set(desc);
      await _dbRef
          .child("books/$bookID/comments/${comment.key}")
          .child("rate")
          .set(rate);
    } catch (e) {
      print("Error with editing comment: " + e.toString());
    }
  }

  Future<void> deleteComment(Book book, Comment comment) async {
    try {
      //Delete comment from book
      await _dbRef
          .child("books/${book.key}")
          .child("comments/${comment.key}")
          .remove();

      //Deleting notfication
      await _dbRef
          .child("notifications/${book.key}")
          .orderByChild("commentId")
          .equalTo(comment.key)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> maps = Map.from(snapshot.value);
        maps.forEach((key, value) async {
          await _dbRef.child("notifications/${book.key}").child(key).remove();
        });
      });
    } catch (e) {
      print("Error with deleting comment: " + e.toString());
    }
  }

  Future<BookFeed> getBooks(String id) async {
    DataSnapshot snapshot = await _dbRef.child("books").once().catchError((e) {
      print("Error getting Books from RTDB for home " + e.toString());
    });

    BookFeed _bookFeed = BookFeed.fromSnapshot(snapshot, id);

    return _bookFeed;
  }

  bool equalsIgnoreCase(String str, String check) {
    print("check");
    print(str.toLowerCase().trim());
    print(check.toLowerCase().trim());
    bool exist = str.toLowerCase().trim() == check.toLowerCase().trim();
    print(exist);
    return exist;
  }

  Future<List<Book>> searchResultBook(String bookTitle, String id) async {
    List<Book> _books = await getBookByRecency(id);
    List<Book> _searchResult = [];

    for (int i = 0; i < _books.length; i++) {
      if (equalsIgnoreCase(_books[i].title, bookTitle) == true) {
        print(_books[i].title);
        _searchResult.add(_books[i]);
      }
      print("not in" + _books[i].title);
    }
    return _searchResult;
  }

  Future<List<Book>> getBookByRecency(String id) async {
    BookFeed books = await getBooks(id);
    List<Book> sorted = books.sortByRecent();

    return sorted;
  }

  Future<List<Book>> getBookByRatings(String id) async {
    BookFeed books = await getBooks(id);
    List<Book> sorted = books.sortByRatings();

    return sorted;
  }

  Future<List<Book>> getBookByVolume(String id) async {
    BookFeed books = await getBooks(id);
    List<Book> sorted = await sortByRecord(books.books);

    return sorted;
  }

  Future<List<Book>> getBooksByCat(String bookCat, String bookId) async {
    List<Book> books = [];
    try {
      await _dbRef
          .child("books")
          .orderByChild("category")
          .equalTo(bookCat)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> maps = Map.from(snapshot.value);
        maps.forEach((key, value) {
          Book _book = Book.fromJson(Map.from(value));
          _book.setKey(key);
          if (bookId != _book.key) {
            print(bookId);
            print(_book.key);
            books.add(_book);
          }
        });
      });
    } catch (e) {
      print("Error with getting books by category : " + e.toString());
    }

    return books;
  }

  Future<List<Comment>> getComments(String bookId) async {
    List<Comment> comments = [];

    await _dbRef
        .child("books/$bookId")
        .orderByChild("dateCreated")
        .once()
        .then((DataSnapshot snapshot) {
      if (Book.fromSnapShot(snapshot).comments != null) {
        comments = Book.fromSnapShot(snapshot).comments;
        Comparator<Comment> dateComparator =
            (a, b) => b.dateCreated.compareTo(a.dateCreated);
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

    Comparator<Book> readersComparator =
        (a, b) => b.readers.compareTo(a.readers);
    sorted.sort(readersComparator);
    return sorted;
  }

  Future<int> checkNoOfReaders(Book book) async {
    int no = 0;

    await _dbRef
        .child("bookRecords")
        .orderByChild("bookId")
        .equalTo(book.key)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<String, dynamic> maps = Map.from(snapshot.value);
        maps.forEach((key, value) {
          no++;
        });
      }
    }).catchError((e) {
      print("Error with checking for number of readers for a book " +
          e.toString());
    });

    return no;
  }
}
