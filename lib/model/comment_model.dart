
import 'package:firebase_database/firebase_database.dart';

class Comment {
  
  String userId;
  String key,commentDesc;
  DateTime dateCreated;
  int rate;

  Comment(this.userId, this.commentDesc, this.rate, this.dateCreated);

  Comment.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"] != null ? snapshot.value["userId"] : null,
    commentDesc = snapshot.value["commentDesc"] != null ? snapshot.value["commentDesc"] : null,
    rate = snapshot.value["rate"] != null ? snapshot.value["rate"] : null,
    dateCreated = snapshot.value["dateCreated"] != null ? convertTimeStampToDateTime(snapshot.value["dateCreated"]) : null;

    Map<String, dynamic> toJson()  {
      return {
          "userId": userId != null ? userId : null,
          "commentDesc" : commentDesc != null ? commentDesc : null ,
          "rate" : commentDesc != null ? rate : null ,
          "dateCreated" : dateCreated != null ? convertDateToTimeStamp(dateCreated)  : null
      };
    }

  factory Comment.fromJson(Map<dynamic, dynamic> parsedJson) {
      return Comment(
        parsedJson["userId"],
        parsedJson["commentDesc"],
        parsedJson["rate"],
        convertTimeStampToDateTime(parsedJson["dateCreated"])
      ); 
  }

  setKey(String key) {
    this.key = key;
  }

}

convertDateToTimeStamp(DateTime date) {
  return date.millisecondsSinceEpoch;
}

convertTimeStampToDateTime(int date) {
  return DateTime.fromMillisecondsSinceEpoch(date);
}

