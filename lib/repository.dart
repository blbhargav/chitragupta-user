import 'dart:core';
import 'dart:math';
import 'package:chitragupta/main.dart';
import 'package:chitragupta/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  final FirebaseAuth _firebaseAuth;
  SharedPreferences prefs;
  final  fbDBRef;
  static String uid;

  Repository({FirebaseAuth firebaseAuth, fbDBRef})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        fbDBRef=fbDBRef ?? Firestore.instance;

  Future signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password);
  }

  Future signUp(String loginId, String password) {
    return  _firebaseAuth.createUserWithEmailAndPassword(
      email: loginId,
      password: password,
    );
  }
  Future sendResetLink(String email){
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut()
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<bool> isUserSignedLocally() async{
    if(prefs==null)
      prefs = await SharedPreferences.getInstance();
    return prefs.getBool("logged_in")??false;
  }
  Future<void> updateUserSignedLocally(bool signed) async {
    if(prefs==null)
      prefs = await SharedPreferences.getInstance();
    return prefs.setBool("logged_in", signed);
  }

  Future<String> getUserId() async{
    print("BLB DB uid started");
    FirebaseUser user=await _firebaseAuth.currentUser();
    uid=user.uid;
    print("BLB DB uid $uid");
    return user.uid;
  }
  Future addSpend(Spend spend) {
    String date=DateFormat('MM-yyyy').format(spend.date);
    print("BLB DB $date");
    return Firestore.instance.runTransaction((Transaction transactionHandler) {
      return Firestore.instance
          .collection("Spends")
          .document(uid).collection(date).document()
          .setData(spend.toJson());
    });
  }


}