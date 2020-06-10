import 'package:firebase_database/firebase_database.dart';

class Comment {
  
  String key, userId, userRole, commentDesc;
  DateTime dateCreated;
  
  Comment(this.userId, this.userRole, this.commentDesc, this.dateCreated);

  Comment.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    userRole = snapshot.value["userRole"],
    commentDesc = snapshot.value["commentDesc"],
    dateCreated = snapshot.value["dateCreated"];

    toJson() {
      return {
        "userId": userId,
        "userRole": userRole,
        "commentDesc" : commentDesc,
        "dateCreated" : dateCreated
      };
    }
  
}
