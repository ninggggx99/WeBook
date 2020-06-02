import 'package:firebase_database/firebase_database.dart';

class User {
  
  String key, firstName, lastName, email, role;
  
  User(this.firstName, this.lastName, this.email, this.role);

  User.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    firstName = snapshot.value["firstName"],
    lastName = snapshot.value["lastName"],
    email = snapshot.value["email"],
    role = snapshot.value["role"];

    toJson() {
      return {
        "firstName" : firstName,
        "lastName" : lastName, 
        "email" : email,
        "role": role
      };
    }
  
}
