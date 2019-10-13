import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:chitragupta/main.dart';
import 'package:chitragupta/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chitragupta/globals.dart' as globals;

class Repository {
  final FirebaseAuth _firebaseAuth;
  SharedPreferences prefs;
  FirebaseDatabase fbDBRef;
  static String uid=globals.UID;
  //String mode="LIVE";
  String mode = "TEST";

  Repository({FirebaseAuth firebaseAuth, fbDBRef})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        fbDBRef = fbDBRef ?? FirebaseDatabase.instance;

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

  Future sendResetLink(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    globals.isLoggedIn=currentUser != null;
    globals.UID=currentUser.uid;
    return currentUser != null;
  }

  Future<bool> isUserSignedLocally() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    return prefs.getBool("logged_in") ?? false;
  }

  Future<void> updateUserSignedLocally(bool signed) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    return prefs.setBool("logged_in", signed);
  }

  Future<String> getUserId() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    uid = user.uid;
    globals.UID=uid;
    return user.uid;
  }

  Future addSpend(Spend spend) {
    String month = DateFormat('MM').format(spend.dateTime);
    String year = DateFormat('yyyy').format(spend.dateTime);
    return fbDBRef
        .reference()
        .child(mode)
        .child("Spends")
        .child(uid)
        .child(year)
        .child(month)
        .push()
        .set(spend.toJson());
  }

  Future<StreamSubscription<Event>> getRecentRecords(void onData(SpendsList spendsList)) async{
    String month = DateFormat('MM').format(DateTime.now());
    String year = DateFormat('yyyy').format(DateTime.now());

    StreamSubscription<Event> subscription = fbDBRef
        .reference()
        .child(mode)
        .child("Spends")
        .child(uid)
        .child(year)
        .child(month)
        .onValue
        .listen((Event event) {
      var spends = new SpendsList.fromSnapshot(event.snapshot);
      onData(spends);
    });

    return subscription;
  }
  Future deleteSpend(Spend spend){
    String month = DateFormat('MM').format(spend.dateTime);
    String year = DateFormat('yyyy').format(spend.dateTime);
    return fbDBRef
        .reference()
        .child(mode)
        .child("Spends")
        .child(uid)
        .child(year)
        .child(month)
        .child(spend.key).remove();
  }
  Future updateSpend(Spend oldspend,Spend newSpend){
      if((oldspend.dateTime.year==newSpend.dateTime.year)&&(oldspend.dateTime.month==newSpend.dateTime.month)){
        String month = DateFormat('MM').format(newSpend.dateTime);
        String year = DateFormat('yyyy').format(newSpend.dateTime);
        return fbDBRef
            .reference()
            .child(mode)
            .child("Spends")
            .child(uid)
            .child(year)
            .child(month)
            .child(oldspend.key).set(newSpend);

      }else{
        deleteSpend(oldspend);
        String month = DateFormat('MM').format(newSpend.dateTime);
        String year = DateFormat('yyyy').format(newSpend.dateTime);
        return fbDBRef
            .reference()
            .child(mode)
            .child("Spends")
            .child(uid)
            .child(year)
            .child(month)
            .child(oldspend.key).set(newSpend);
      }

  }
}
