import 'package:firebase_database/firebase_database.dart';

class Book {
  
  String key, title, desc, coverURL, authorId,  authorName, bookURL;
  int rating;
  
  Book(this.title, this.desc, this.coverURL, this.rating, this.authorId, this.authorName, this.bookURL);

  Book.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    title = snapshot.value["title"],
    desc = snapshot.value["desc"],
    coverURL = snapshot.value["coverURL"],
    rating = snapshot.value["rating"],
    authorId = snapshot.value["authorId"],
    authorName = snapshot.value["authorName"],
    bookURL = snapshot.value["bookURL"];

    toJson() {
      return {
        "title" : title,
        "desc" : desc, 
        "coverURL" : coverURL,
        "rating" : rating,
        "authorId": authorId,
        "authorName": authorName,
        "bookURL": bookURL
      };
    }
  
}
