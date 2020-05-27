import 'package:firebase_database/firebase_database.dart';

class User {
  
  String key, firstName, lastName, email, password, role;
  
  User(this.firstName, this.lastName, this.email, this.password, this.role);

  String get fName {
    return firstName;
  }

  User.fromSnapShot(DataSnapshot snapshot) :
    key = snapshot.key,
    firstName = snapshot.value["firstName"],
    lastName = snapshot.value["lastName"],
    email = snapshot.value["email"],
    password = snapshot.value["password"],
    role = snapshot.value["role"];

    toJson() {
      return {
        "firstName" : firstName,
        "lastName" : lastName, 
        "email" : email,
        "password": password,
        "role": role
      };
    }
  
}

//The roles for accounts
enum roles {
  bookworm,
  aspiring_writer,
  professional_writer
}
