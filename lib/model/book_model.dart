
import 'package:firebase_database/firebase_database.dart';
import 'package:webookapp/model/comment_model.dart';

class Book {
  
  String key, title, description, category, coverURL, authorId, authorName, bookURL;
  int rating;
  List<Comment> comments;
  
  Book(this.title, this.description, this.category, this.coverURL, this.rating, this.comments, this.authorId, this.authorName, this.bookURL);

  Book.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    title = snapshot.value["title"],
    description = snapshot.value["description"],
    category = snapshot.value["category"],
    coverURL = snapshot.value["coverURL"],
    rating = snapshot.value["rating"],
    comments = snapshot.value["comments"],
    authorId = snapshot.value["authorId"],
    authorName = snapshot.value["authorName"],
    bookURL = snapshot.value["bookURL"];

    toJson() {
      return {
        "title" : title,
        "description" : description, 
        "category": category,
        "coverURL" : coverURL,
        "rating" : rating,
        "comments" : comments,
        "authorId": authorId,
        "authorName": authorName,
        "bookURL": bookURL
      };
    }

  factory Book.fromJson(Map<String,dynamic> parsedJson) {
    return Book(
      parsedJson["title"],
      parsedJson["description"],
      parsedJson["category"],
      parsedJson["coverURL"],
      parsedJson["rating"],
      parsedJson["comments"],
      parsedJson["authorId"],
      parsedJson["authorName"],
      parsedJson["bookURL"]);
  }
  
  setKey(String key) {
    this.key = key;
  }

}
