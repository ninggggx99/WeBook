import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:webookapp/model/book_model.dart';
import 'package:webookapp/model/comment_model.dart';
import 'package:webookapp/model/user_model.dart';
import 'package:webookapp/view_model/auth_provider.dart';
import 'package:webookapp/model/notification_model.dart';

class NotiProvider {
  DatabaseReference _dbRef;

  NotiProvider() {
    _dbRef = FirebaseDatabase.instance.reference().child("notifications");
  }

  Future<List<Message>> getNoti(String uid) async {
    List<Message> notis = [];

    try {
      await _dbRef
          .child(uid)
          .limitToLast(10)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Map<dynamic, dynamic> maps = Map.from(snapshot.value);
          maps.forEach((key, value) {
            Message m = Message.fromJson(Map.from(value));
            m.key = key;
            notis.add(m);
          });
        }
      });

      Comparator<Message> recencyComparator =
          (a, b) => b.dateTime.compareTo(a.dateTime);

      notis.sort(recencyComparator);
    } catch (e) {
      print("Error with getting noti : " + e.toString());
    }

    return notis;
  }
  Future<List<Message>> getTodayNoti(String uid) async {
    List<Message> notis = [];
    final now = DateTime.now();
    try {
      await _dbRef
          .child(uid)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Map<dynamic, dynamic> maps = Map.from(snapshot.value);
          maps.forEach((key, value) {
            print("snapped");
            Message m = Message.fromJson(Map.from(value));
            m.key = key;
            if (now.year == m.dateTime.year && now.month == m.dateTime.month && now.day == m.dateTime.day){
              print("added");
              notis.add(m);
            }
           
          });
        }
      });

      Comparator<Message> recencyComparator =
          (a, b) => b.dateTime.compareTo(a.dateTime);

      notis.sort(recencyComparator);
    } catch (e) {
      print("Error with getting noti : " + e.toString());
    }

    return notis;
  }
  Future<List<Message>> getWeekNoti(String uid) async {
    List<Message> notis = [];
    final now = DateTime.now();
    print("weeknoti");
    try {
      await _dbRef
          .child(uid)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          Map<dynamic, dynamic> maps = Map.from(snapshot.value);
          maps.forEach((key, value) {
            print("snapped");
            Message m = Message.fromJson(Map.from(value));
            m.key = key;
            print(now.difference(m.dateTime).inDays);
            if (now.difference(m.dateTime).inDays <= 7 && (now.year == m.dateTime.year && now.month == m.dateTime.month && now.day != m.dateTime.day)){
              print("added");
              notis.add(m);
            }           
          });
        }
      });

      Comparator<Message> recencyComparator =
          (a, b) => b.dateTime.compareTo(a.dateTime);

      notis.sort(recencyComparator);
    } catch (e) {
      print("Error with getting noti : " + e.toString());
    }
    print(notis);
    return notis;
  }
  Future<void> createNoti(Message message, String uid) async {
    String key = _dbRef.child(uid).push().key;

    //This is to create list of noti under the user's id
    try {
      await _dbRef.child(uid).child(key).set(message.toJson());
    } catch (e) {
      print("Error with creating noti: " + e.toString());
    }
  }

  Future <List<Book>> getCommentedBook (List<Message> notiList) async{
    DatabaseReference _dbRefBook = FirebaseDatabase.instance.reference().child("books");
    List<Book> books = [];
    for (Message message in notiList){
      await _dbRefBook.child(message.bookId).once().then((DataSnapshot snapshot){
        books.add(Book.fromSnapShot(snapshot));
      });
    }
    return books;
  } 
  Future <List<User>> getCommentedUser (List<Message> notiList) async{
    DatabaseReference _dbRefUser = FirebaseDatabase.instance.reference().child("users");
    List<User> users = [];
    for (Message message in notiList){
      await _dbRefUser.child(message.userId).once().then((DataSnapshot snapshot){
        users.add(User.fromSnapShot(snapshot));
      });
    }
    return users;
  } 
  Future <List<Comment>> getCommentedComment (List<Message> notiList) async{
    DatabaseReference _dbRefBook = FirebaseDatabase.instance.reference().child("books");
    List<Comment> comments = [];
    List<Comment> commentList = [];
    for (Message message in notiList){
      await _dbRefBook.child(message.bookId).once().then((DataSnapshot snapshot){
        if (Book.fromSnapShot(snapshot).comments != null) {
          comments = Book.fromSnapShot(snapshot).comments;
        }
        for (Comment comment in comments){
          if (comment.key == message.commentId){
            commentList.add(comment);
          }
        }
      });
    }
    return commentList;
  } 
}
