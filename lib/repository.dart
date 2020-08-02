import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:chitragupta/app/home.dart';
import 'package:chitragupta/app/spends.dart';
import 'package:chitragupta/main.dart';
import 'package:chitragupta/models/Product.dart';
import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chitragupta/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class Repository {
  FirebaseAuth _firebaseAuth;
  SharedPreferences prefs;
  FirebaseDatabase fbDBRef;
  static String uid = globals.UID;
  final databaseReference = Firestore.instance;
  User user;

  Repository({FirebaseAuth firebaseAuth, fbDBRef}) {
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    this.fbDBRef = fbDBRef ?? FirebaseDatabase.instance;
    this.fbDBRef.setPersistenceEnabled(true);
    databaseReference.settings(persistenceEnabled: true);
    getUserId();
  }

  Future signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future signUp(String loginId, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: loginId,
      password: password,
    );
  }

  Future createUserProfile(User user) {
    return fbDBRef
        .reference()
        .child("Profile")
        .child(user.uid)
        .set(user.toJson());
  }

  Future updatePassword(String newPassword, FirebaseUser res) async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser.updatePassword(newPassword);
  }

  Future reAuthenticateUser(String oldPassword) async {
    final currentUser = await _firebaseAuth.currentUser();
    AuthCredential authCredential = EmailAuthProvider.getCredential(
      email: currentUser.email,
      password: oldPassword,
    );
    return currentUser.reauthenticateWithCredential(authCredential);
  }

  Future sendResetLink(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    globals.isLoggedIn = currentUser != null;
    if (currentUser != null){
      globals.UID = currentUser.uid;
      uid= currentUser.uid;
    }
    return currentUser != null;
  }

  Future<bool> isUserSignedLocally() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    return prefs.getBool("logged_in") ?? false;
  }

  Future<void> updateUserSignedLocally(bool signed, String uid) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    prefs.setString("uid", uid);
    Repository.uid= uid;
    globals.UID=uid;
    return prefs.setBool("logged_in", signed);
  }

  Future<String> getUserId() async {
    if(globals.UID==null){
      if (prefs == null) prefs = await SharedPreferences.getInstance();
      if (prefs.getString("uid") != null) {
        Repository.uid = prefs.getString("uid");
      } else {
        FirebaseUser user = await _firebaseAuth.currentUser();
        Repository.uid = user.uid;
        uid=user.uid;
        prefs.setString("uid", Repository.uid);
      }
    }else{
      Repository.uid=globals.UID;
    }
    return Repository.uid;
  }

  getUserProfile() async {
    if (uid == null) {
      await getUserId();
    }
    return databaseReference.collection("Users").document(uid).get();
  }

  getActiveOrders() {
    Stream<QuerySnapshot> reference = databaseReference
        .collection("Orders")
        .where("adminId", isEqualTo: user.adminId)
        .where("status", isEqualTo: 1)
        .orderBy("date", descending: false)
        .limit(25)
        .snapshots();

    return reference;
  }

  Future<List<Product>> getProductsByEmployee(String orderId) async {
    List<Product> indentList=List();
    QuerySnapshot snapshot = await databaseReference
        .collection('Orders')
        .document(orderId)
        .collection("products")
        //.where("empolyeeId",isEqualTo: uid)
        .getDocuments();
    if (snapshot.documents.length > 0) {
      snapshot.documents.forEach((element) {
        Product product = Product.fromSnapshot(snapshot: element);
        if(product.employeeId == uid)
          indentList.add(product);
      });
    }
    return indentList;
  }

  getOrder(String orderId) {
    Stream<DocumentSnapshot> reference =
        databaseReference.collection("Orders").document(orderId).snapshots();
    return reference;
  }

  getOrderProducts(String orderId) {
    Stream<QuerySnapshot> reference = databaseReference
        .collection("Orders")
        .document(orderId)
        .collection("products")
        .where("employeeId",isEqualTo: uid)
        .orderBy("purchasedQty", descending: false)
        .snapshots();
    return reference;
  }

  updatePurchaseQuantity(String orderId, String productId, int purchasedQty, int amountSpent){
    databaseReference
        .collection("Orders")
        .document(orderId)
        .collection("products")
        .document(productId)
        .updateData({
      "purchasedQty": purchasedQty,
      "amountSpent": amountSpent,
      "payer": user.name,
      "payerId":"${user.uid}"
    });

    databaseReference.collection("Orders").document(orderId).updateData({
      "procuredItems": FieldValue.increment(1),
      "amountSpent": FieldValue.increment(amountSpent),
      "${user.uid}": FieldValue.increment(amountSpent)
    });
    //
  }

  /*
  *
  *
  *
  * Old Data
  *
  *
  *
  *
  * */

  Future addSpend(Spend spend) async {
    String month = DateFormat('MM').format(spend.dateTime);
    String year = DateFormat('yyyy').format(spend.dateTime);
    DatabaseReference spendRef =
        fbDBRef.reference().child("Spends").child(uid).child(year).child(month);
    spendRef.keepSynced(true);

    return spendRef.push().set(spend.toJson());
  }

  Future<StreamSubscription<Event>> getRecentRecords(
      void onData(SpendsList spendsList)) async {
    String month = DateFormat('MM').format(DateTime.now());
    String year = DateFormat('yyyy').format(DateTime.now());

    DatabaseReference spendsRef =
        fbDBRef.reference().child("Spends").child(uid).child(year).child(month);

    spendsRef.keepSynced(true);

    StreamSubscription<Event> subscription =
        spendsRef.onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        var spends = new SpendsList.fromSnapshot(event.snapshot);
        onData(spends);
      } else {
        onData(null);
      }
    });

    return subscription;
  }

  Future<StreamSubscription<Event>> getSpendRecord(
      Spend payload, void onData(Spend spend)) async {
    String month = DateFormat('MM').format(payload.dateTime);
    String year = DateFormat('yyyy').format(payload.dateTime);

    DatabaseReference spendsRef = fbDBRef
        .reference()
        .child("Spends")
        .child(uid)
        .child(year)
        .child(month)
        .child(payload.key);
    spendsRef.keepSynced(true);

    StreamSubscription<Event> subscription =
        spendsRef.onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        print("BLB no observable spend ${event.snapshot.key}");
        var spends = new Spend.fromSnapshot(event.snapshot);

        onData(spends);
      } else {
        onData(null);
      }
    });

    return subscription;
  }

  Future getSpendYears() {
    return http.get(
        'https://chitragupta-007.firebaseio.com/Spends/$uid.json?shallow=true');
  }

  Future deleteSpend(Spend spend) async {
    String month = DateFormat('MM').format(spend.dateTime);
    String year = DateFormat('yyyy').format(spend.dateTime);
    return fbDBRef
        .reference()
        .child("Spends")
        .child(uid)
        .child(year)
        .child(month)
        .child(spend.key)
        .remove();
  }

  Future updateSpend(Spend oldSpend, Spend newSpend) async {
    if ((oldSpend.dateTime.year == newSpend.dateTime.year) &&
        (oldSpend.dateTime.month == newSpend.dateTime.month)) {
      String month = DateFormat('MM').format(newSpend.dateTime);
      String year = DateFormat('yyyy').format(newSpend.dateTime);

      return fbDBRef
          .reference()
          .child("Spends")
          .child(uid)
          .child(year)
          .child(month)
          .child(oldSpend.key)
          .set(newSpend.toJson());
    } else {
      deleteSpend(oldSpend);
      String month = DateFormat('MM').format(newSpend.dateTime);
      String year = DateFormat('yyyy').format(newSpend.dateTime);
      return fbDBRef
          .reference()
          .child("Spends")
          .child(uid)
          .child(year)
          .child(month)
          .child(oldSpend.key)
          .set(newSpend.toJson());
    }
  }

  Future<StreamSubscription<Event>> getYearlyRecords(String year,
      void onData(List<int> months, List<SpendsList> spendList)) async {
    DatabaseReference spendsRef =
        fbDBRef.reference().child("Spends").child(uid).child(year);
    spendsRef.keepSynced(true);

    StreamSubscription<Event> subscription =
        spendsRef.onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        List<int> months = new List();
        List<SpendsList> spendList = new List();

        var keys = event.snapshot.value.keys;
        List<dynamic> keyStrings = keys.toList();
        keyStrings.sort((a, b) => a.compareTo(b));

        for (final key in keyStrings) {
          months.add(int.parse(key));
          var spends = new SpendsList.fromJson(event.snapshot.value[key]);
          spends.spendList.sort((a, b) {
            var adate = a.dateTime;
            var bdate = b.dateTime;
            return adate.compareTo(bdate);
          });
          spendList.add(spends);
        }

        onData(months, spendList);
      } else {
        onData(null, null);
      }
    });

    return subscription;
  }

  Future<StreamSubscription<Event>> getMonthlyRecords(
      String year, String month, void onData(List<Spend> spendList)) async {
    DatabaseReference spendsRef =
        fbDBRef.reference().child("Spends").child(uid).child(year).child(month);
    spendsRef.keepSynced(true);

    StreamSubscription<Event> subscription =
        spendsRef.onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        List<Spend> spendList = new List();

        var spends = new SpendsList.fromJson(event.snapshot.value);
        spendList.addAll(spends.spendList);

        onData(spendList);
      } else {
        onData(null);
      }
    });

    return subscription;
  }

  Future<StreamSubscription<Event>> getYearlyListRecords(
      String year, void onData(List<Spend> spendList)) async {
    DatabaseReference spendsRef =
        fbDBRef.reference().child("Spends").child(uid).child(year);
    spendsRef.keepSynced(true);

    StreamSubscription<Event> subscription =
        spendsRef.onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        List<Spend> spendList = new List();

        var keys = event.snapshot.value.keys;
        List<dynamic> keyStrings = keys.toList();
        keyStrings.sort((a, b) => a.compareTo(b));

        for (final key in keyStrings) {
          var spends = new SpendsList.fromJson(event.snapshot.value[key]);
          spends.spendList.sort((a, b) {
            var adate = a.dateTime;
            var bdate = b.dateTime;
            return adate.compareTo(bdate);
          });
          spendList.addAll(spends.spendList);
        }

        onData(spendList);
      } else {
        onData(null);
      }
    });

    return subscription;
  }

  Future<StreamSubscription<Event>> getAllSpendRecords(
      void onData(List<Spend> spend)) async {
    DatabaseReference spendsRef =
        fbDBRef.reference().child("Spends").child(uid);
    spendsRef.keepSynced(true);

    StreamSubscription<Event> subscription =
        spendsRef.onValue.listen((Event event) {
      if (event.snapshot.value != null) {
        List<Spend> spendList = new List();

        var yearKeys = event.snapshot.value.keys;
        for (final year in yearKeys) {
          var monthKeys = event.snapshot.value[year].keys;
          for (final key in monthKeys) {
            var spends =
                new SpendsList.fromJson(event.snapshot.value[year][key]);
            spendList.addAll(spends.spendList);
          }
        }

        onData(spendList);
      } else {
        onData(null);
      }
    });

    return subscription;
  }
}
