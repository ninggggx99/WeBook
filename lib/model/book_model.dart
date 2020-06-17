
import 'package:firebase_database/firebase_database.dart';
import 'package:webookapp/model/comment_model.dart';
import 'package:webookapp/model/rating_model.dart';
class Book {
  
  String key, title, description, category, coverURL, authorId, authorName, bookURL;
  
  List<Rating> ratings;

  List<Comment> comments;
  
  Book(this.title, this.description, this.category, this.coverURL, this.ratings, this.comments, this.authorId, this.authorName, this.bookURL);

  Book.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    title = snapshot.value["title"] != null ? snapshot.value["title"] : null,
    description = snapshot.value["description"] != null ? snapshot.value["description"] : null,
    category = snapshot.value["category"] != null ? snapshot.value["category"] : null,
    coverURL = snapshot.value["coverURL"] != null ? snapshot.value["coverURL"] : null,
    ratings = snapshot.value["ratings"] != null ? convertRatings(snapshot.value["ratings"]) : null,
    comments = snapshot.value["comments"] != null ? convertComments(snapshot.value["comments"]) : null,
    authorId = snapshot.value["authorId"] != null ? snapshot.value["authorId"] : null,
    authorName = snapshot.value["authorName"] != null ? snapshot.value["authorName"] : null,
    bookURL = snapshot.value["bookURL"] != null ? snapshot.value["bookURL"] : null;

    toJson() {
      return {
        "title" : title != null ? title : null,
        "description" : description != null ? description : null, 
        "category": category != null ? category : null,
        "coverURL" : coverURL != null ? coverURL : null,
        "ratings" : ratings != null ? List<dynamic>.from(ratings.map((e) => e.toJson())) : null,
        "comments" : comments != null ? List<dynamic>.from(comments.map((x) => x.toJson())) : null,
        "authorId": authorId != null ? authorId : null,
        "authorName": authorName != null ? authorName : null,
        "bookURL": bookURL != null ? bookURL : null
      };
    }

  factory Book.fromJson(Map<String,dynamic> parsedJson) {

    return Book(
      parsedJson["title"] != null ? parsedJson["title"] : null, 
      parsedJson["description"] != null ? parsedJson["description"] : null,
      parsedJson["category"] != null ? parsedJson["category"] : null,
      parsedJson["coverURL"] != null ? parsedJson["coverURL"] : null,
      parsedJson["ratings"] != null ? convertRatings(parsedJson["ratings"]) : null,
      parsedJson["comments"] != null ? convertComments(parsedJson["comments"]) : null,
      parsedJson["authorId"] != null ? parsedJson["authorId"] : null,
      parsedJson["authorName"] != null ? parsedJson["authorName"] : null,
      parsedJson["bookURL"] != null ? parsedJson["bookURL"] : null);
  }
  
  setKey(String key) {
    this.key = key;
  }

  addComment(Comment comment) {
    this.comments.add(comment);
  }

}

List<Comment> convertComments(Map<dynamic, dynamic> data) {

  List<Comment> comments = [];
  
  Map<String, dynamic> parsedJson = Map.from(data);

  parsedJson.forEach((key, value) {

    Map<String, dynamic> co = Map.from(value);
    Comment c = Comment.fromJson(co);
    c.setKey(key);
    comments.add(c);

  });

  return comments;
}

List<Rating> convertRatings(Map<dynamic, dynamic> data) {

  List<Rating> ratings = [];
  
  Map<String, dynamic> parsedJson = Map.from(data);
  print(parsedJson);

  parsedJson.forEach((key, value) {

    Map<String, dynamic> ra = Map.from(value);
    print(ra["userId"]);
    Rating r = Rating.fromJson(ra);
    r.setKey(key);
    ratings.add(r);

  });

  print(ratings);
  return ratings;
}
