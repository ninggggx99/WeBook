import 'package:firebase_database/firebase_database.dart';

import 'book_model.dart';

class BookFeed{

  List<Book> books;

  BookFeed({this.books});

  BookFeed.fromSnapshot(DataSnapshot snapshot) : 
      books = parseBooks(snapshot);
 
  static List<Book> parseBooks(DataSnapshot snapshot){
    
    List<Book> bookList = new List();
    Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
    mapOfMaps.forEach((key, value) {
      Book book = Book.fromJson(Map.from(value));
      book.setKey(key);
      bookList.add(book);
    });

    return bookList;
  }

}