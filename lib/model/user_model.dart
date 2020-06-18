import 'package:firebase_database/firebase_database.dart';

class User {
  
  String key, profilePic, firstName, lastName, email, role;
  
  User(this.profilePic, this.firstName, this.lastName, this.email, this.role);

  User.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    profilePic = snapshot.value["profilePic"] != null ? snapshot.value["profilePic"] : null ,
    firstName = snapshot.value["firstName"] != null ? snapshot.value["firstName"] : null,
    lastName = snapshot.value["lastName"] != null ? snapshot.value["lastName"] : null,
    email = snapshot.value["email"] != null ? snapshot.value["email"] : null,
    role = snapshot.value["role"] != null ? snapshot.value["role"] : null;

    toJson() {
      return {
        "profilePic": profilePic != null ? profilePic : null,
        "firstName" : firstName != null ? firstName : null,
        "lastName" : lastName != null ? lastName : null, 
        "email" : email != null ? email : null,
        "role": role != null ? role : null
      };
    }

    factory User.fromJson(Map<String,dynamic> parsedJson) {
      return User(
        parsedJson["profilePic"] != null ? parsedJson["profilePic"] : null,
        parsedJson["firstName"] != null ? parsedJson["firstName"] : null,
        parsedJson["lastName"] != null ? parsedJson["lastName"] : null,
        parsedJson["email"] != null ? parsedJson["email"] : null,
        parsedJson["role"] != null ? parsedJson["role"] : null,
      );
    }

    setKey(String key) {
      this.key = key;
    }
  
}