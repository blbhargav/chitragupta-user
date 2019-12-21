import 'package:firebase_database/firebase_database.dart';

class User {
  String uid,email,name,profileImage;
  User({this.uid,this.email,this.name,this.profileImage});

  User.fromSnapshot({DataSnapshot snapshot})
      :uid = snapshot.value['uid'],email = snapshot.value['email'],name = snapshot.value['name'],profileImage = snapshot.value['profileImage'];

  toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "profileImage": profileImage
    };
  }
}