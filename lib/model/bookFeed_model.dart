import 'package:firebase_database/firebase_database.dart';

import 'book_model.dart';
import 'comment_model.dart';

class BookFeed{

  List<Book> books;

  BookFeed({this.books});

  BookFeed.fromSnapshot(DataSnapshot snapshot, String userId) : 
      books = parseBooks(snapshot, userId);
 
  static List<Book> parseBooks(DataSnapshot snapshot, String userId){
    
    List<Book> bookList = new List();
    Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
    mapOfMaps.forEach((key, value) {
      //This excludes the user's books
      if (value["authorId"] != userId ) {
        Book book = Book.fromJson(Map.from(value));
        book.setKey(key);
        bookList.add(book);
      }
    });

    return bookList;
  }

  List<Book> sortByRecent() {

    List<Book> sorted = this.books;
    Comparator<Book> dateComparator = (a, b) => b.dateCreated.compareTo(a.dateCreated);
    sorted.sort(dateComparator);
    return sorted;

  }

  double calculateAverageRating(Book b) {

    List<Comment> comments = b.comments;
    if (comments != null) {
      int noRate = comments.length;
      double total = 0;
      for (Comment c in comments) {
        total += c.rate;
      }
      
      if (total == 0) {
        return 0;
      } 

      double avg = double.parse((total/noRate).toStringAsFixed(2));

      return avg;
    } else {
      return 0;
    }

  }
  
  List<Book> sortByRatings() {

    List<Book> sorted = this.books;
    Comparator<Book> rateComparator = (a, b) => calculateAverageRating(b).compareTo(calculateAverageRating(a));
    sorted.sort(rateComparator);
    return sorted;
    
  }

}