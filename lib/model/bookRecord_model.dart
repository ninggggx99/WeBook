import 'package:firebase_database/firebase_database.dart';

class BookRecord {
  
  String key, bookId, userId;
  bool like;
  
  BookRecord(this.bookId, this.userId, this.like);

  BookRecord.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    bookId = snapshot.value["bookId"],
    userId = snapshot.value["userId"],
    like = snapshot.value["like"];

    toJson() {
      return {
        "bookId" : bookId,
        "userId" : userId, 
        "like" : like
      };
    }

    factory BookRecord.fromJson(Map<String,dynamic> parsedJson) {
//    print(parsedJson);
    return BookRecord(
      parsedJson["bookId"],
      parsedJson["userId"],
      parsedJson["like"],
    );

  }
  
}
