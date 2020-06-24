/*import 'package:firebase_database/firebase_database.dart';

class Rating {
  
  String key, userId;
  double rate;
  
  Rating(this.userId, this.rate);

  Rating.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"] != null ? snapshot.value["userId"] : null,
    rate = snapshot.value["rate"] != null ? snapshot.value["rate"] : null;
    
    toJson() {
      return {
        "userId": userId != null ? userId : null,
        "rate": rate != null ? rate : null,
      };
    }

  factory Rating.fromJson(Map<String,dynamic> parsedJson) {
      return Rating(
        parsedJson["userId"] != null ? parsedJson["userId"] : null,
        parsedJson["rate"] != null ? (parsedJson["rate"].toDouble()) : null
      );
  }

  setKey(String key) {
    this.key = key;
  }
}*/
