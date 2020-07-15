import 'package:firebase_database/firebase_database.dart';

class BookRecord {
  
  String key, bookId, userId;
  bool like;
  bool download;
  
  BookRecord(this.bookId, this.userId, this.like, this.download);

  BookRecord.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    bookId = snapshot.value["bookId"] != null ? snapshot.value["bookId"] : null,
    userId = snapshot.value["userId"] != null ? snapshot.value["userId"] : null,
    like = snapshot.value["like"] != null ? snapshot.value["like"] : null,
    download = snapshot.value["download"] != null ? snapshot.value["download"] : null;

    toJson() {
      return {
        "bookId" : bookId != null ? bookId : null ,
        "userId" : userId != null ? userId : null, 
        "like" : like != null ? like : null,
        "download" : download != null ? download : null
      };
    }

    factory BookRecord.fromJson(Map<String,dynamic> parsedJson) {
    return BookRecord(
      parsedJson["bookId"] != null ? parsedJson["bookId"] : null,
      parsedJson["userId"] != null ? parsedJson["userId"] : null,
      parsedJson["like"] != null ? parsedJson["like"] : null,
      parsedJson["download"] != null ? parsedJson["download"] : null
    );

  }
  
}
// import 'package:firebase_database/firebase_database.dart';

// class BookRecord {
  
//   String key, bookId, userId;

//   DateTime dateCreated;
//   BookRecord(this.bookId, this.userId, this.dateCreated);

//   BookRecord.fromSnapShot(DataSnapshot snapshot) :
//     key = snapshot.key,
//     bookId = snapshot.value["bookId"] != null ? snapshot.value["bookId"] : null,
//     userId = snapshot.value["userId"] != null ? snapshot.value["userId"] : null,
//     dateCreated = snapshot.value["dateCreated"] != null ? convertTimeStampToDateTime(snapshot.value["dateCreated"]) : null;

//     toJson() {
//       return {
//         "bookId" : bookId != null ? bookId : null ,
//         "userId" : userId != null ? userId : null, 
//         "dateCreated" : dateCreated != null ? convertDateToTimeStamp(dateCreated)  : null
//       };
//     }

//     factory BookRecord.fromJson(Map<String,dynamic> parsedJson) {

//     return BookRecord(
//       parsedJson["bookId"] != null ? parsedJson["bookId"] : null,
//       parsedJson["userId"] != null ? parsedJson["userId"] : null,
//       convertTimeStampToDateTime(parsedJson["dateCreated"])
//     );

//   }
  
// }

// convertDateToTimeStamp(DateTime date) {
//   return date.millisecondsSinceEpoch;
// }

// convertTimeStampToDateTime(int date) {
//   return DateTime.fromMillisecondsSinceEpoch(date);
// }
