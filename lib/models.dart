import 'package:cloud_firestore/cloud_firestore.dart';

class Spend{
  Spend();
  String id,amount; String title; String category; DateTime date; String description;

  Spend.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        amount = snapshot['amount'],
        category = snapshot['category'],
        date = snapshot['date'],
        title = snapshot['title'],
        description = snapshot['description'];

  toJson(){
    return {
      "amount":amount,
      "category":category,
      "date":date,
      "description":description,
      "title":title

    };
  }
}