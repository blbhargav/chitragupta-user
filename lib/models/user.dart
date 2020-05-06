import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class User {
  String adminId;
  String email;
  String mobile;
  String name;
  String uid,id;

  User({this.adminId, this.email, this.mobile, this.name, this.uid});

  User.fromJson(Map<String, dynamic> json) {
    adminId = json['adminId'];
    email = json['email'];
    mobile = json['mobile'];
    name = json['name'];
    uid = json['userId'];
  }
  User.fromSnapshot({DocumentSnapshot snapshot}) {
    adminId = snapshot.data['adminId'];
    email = snapshot.data['email'];
    mobile = snapshot.data['mobile'];
    name = snapshot.data['name'];
    uid = snapshot.data['userId'];
    id=snapshot.documentID;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adminId'] = this.adminId;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['userId'] = this.uid;
    return data;
  }
}