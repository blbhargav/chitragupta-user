import 'dart:core';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
  final FirebaseAuth _firebaseAuth;
  SharedPreferences prefs;
  final DatabaseReference fbDBRef;

  Repository({FirebaseAuth firebaseAuth, DatabaseReference fbDBRef})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        fbDBRef=fbDBRef ?? FirebaseDatabase.instance.reference();

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

}