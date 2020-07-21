import 'package:firebase_database/firebase_database.dart';
import 'package:webookapp/model/notification_model.dart';

class NotiProvider {
  DatabaseReference _dbRef;

  NotiProvider() {
    _dbRef = FirebaseDatabase.instance.reference().child("notifications");
  }

  Future<List<Message>> getNoti(String uid) async {
    List<Message> notis = new List<Message>();

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

  Future<void> createNoti(Message message, String uid) async {
    String key = _dbRef.child(uid).push().key;

    //This is to create list of noti under the user's id
    try {
      await _dbRef.child(uid).child(key).set(message.toJson());
    } catch (e) {
      print("Error with creating noti: " + e.toString());
    }
  }
}
