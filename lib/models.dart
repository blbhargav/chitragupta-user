import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Spend {
  Spend();
  int amount;
  String key;
  String title;
  String category;
  DateTime dateTime;
  String description;

  Spend.fromSnapshot({String key, DataSnapshot snapshot})
      : key = snapshot.key,
        amount = snapshot.value['amount'],
        category = snapshot.value['category'],
        dateTime =
            DateTime.fromMillisecondsSinceEpoch(snapshot.value['dateTime']),
        title = snapshot.value['title'],
        description = snapshot.value['description'];

  toJson() {
    return {
      "amount": amount,
      "category": category,
      "dateTime": dateTime.millisecondsSinceEpoch,
      "description": description,
      "title": title
    };
  }

  Spend.fromJson(var json)
      : amount = json['amount'],
        category = json['category'],
        dateTime = DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
        description = json['description'],
        title = json['title'];

  static fromSnapshotToList(DataSnapshot snapshot) {
    List<Spend> spendList = [];
    print(snapshot.key);
    Map<dynamic, dynamic> spends = snapshot.value;
    spends.forEach((key, value) {
      Spend spend = Spend.fromJson(value);
      spend.key = key;
      spendList.add(spend);
    });

    return spendList;
  }
}

class SpendsList {
  List<Spend> spendList;
  SpendsList({this.spendList});
  SpendsList.fromSnapshot(DataSnapshot snapshot)
      : spendList = Spend.fromSnapshotToList(snapshot);
}
