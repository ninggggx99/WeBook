import 'package:firebase_database/firebase_database.dart';

class Message {
  String key;
  String title;
  String body;
  String userId;
  String commentId;
  DateTime dateTime;
  String bookId;

  Message({this.title, this.body, this.dateTime, this.userId, this.commentId, this.bookId});

  Message.fromSnapShot(DataSnapshot snapshot) :
        key = snapshot.key,
        title = snapshot.value["title"],
        body = snapshot.value["body"],
        userId = snapshot.value["userId"],
        commentId = snapshot.value["commentId"],
        dateTime = convertTimeStampToDateTime(snapshot.value["dateTime"]),
        bookId = snapshot.value["bookId"];

  toJson() {
    return {
      "title": title != null ? title : null,
      "body": body != null ? body : null,
      "userId": userId != null ? userId : null,
      "commentId": commentId != null ? commentId : null,
      "dateTime": dateTime != null ? convertDateToTimeStamp(dateTime) : null,
      "bookId" : bookId != null ? bookId : null
    };
  }

  factory Message.fromJson(Map<String, dynamic> parsedJson) {
    return Message(
      title: parsedJson["title"] != null ? parsedJson["title"] : null,
      body: parsedJson["body"] != null ? parsedJson["body"] : null,
      dateTime: convertTimeStampToDateTime(parsedJson["dateTime"]),
      userId: parsedJson["userId"] != null ? parsedJson["userId"] : null,
      commentId:
          parsedJson["commentId"] != null ? parsedJson["commentId"] : null,
      bookId: parsedJson["bookId"] != null ? parsedJson ["bookId"] : null
    );
  }
}

convertDateToTimeStamp(DateTime date) {
  return date.millisecondsSinceEpoch;
}

convertTimeStampToDateTime(int date) {
  return DateTime.fromMillisecondsSinceEpoch(date);
}
