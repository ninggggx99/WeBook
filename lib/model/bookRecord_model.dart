import 'package:firebase_database/firebase_database.dart';

class BookRecord {
  
  String key, bookId, userId;
  
  BookRecord(this.bookId, this.userId);

  BookRecord.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    bookId = snapshot.value["bookId"],
    userId = snapshot.value["userId"];

    toJson() {
      return {
        "bookId" : bookId,
        "userId" : userId, 
      };
    }
  
}
