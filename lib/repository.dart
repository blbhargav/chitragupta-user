import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:chitragupta/app/spends.dart';
import 'package:chitragupta/main.dart';
import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chitragupta/globals.dart' as globals;

class Repository {
  FirebaseAuth _firebaseAuth;
  SharedPreferences prefs;
  FirebaseDatabase fbDBRef;
  static String uid = globals.UID;

  Repository({FirebaseAuth firebaseAuth, fbDBRef}) {
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    this.fbDBRef = fbDBRef ?? FirebaseDatabase.instance;
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
    if (currentUser != null) globals.UID = currentUser.uid;
    return currentUser != null;
  }

  Future<bool> isUserSignedLocally() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    return prefs.getBool("logged_in") ?? false;
  }

  Future<void> updateUserSignedLocally(bool signed, String uid) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    prefs.setString("uid", uid);
    return prefs.setBool("logged_in", signed);
  }

  Future<String> getUserId() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    if (prefs.getString("uid") != null) {
      uid = prefs.getString("uid");
    } else {
      FirebaseUser user = await _firebaseAuth.currentUser();
      uid = user.uid;
      prefs.setString("uid", uid);
    }

    globals.UID = uid;
    return uid;
  }

  Future<StreamSubscription<Event>> getUserProfile(void onData(User user)) async{

    StreamSubscription<Event> subscription = fbDBRef
        .reference()
        .child("Profile")
        .child(uid)
        .onValue
        .listen((Event event) {
      if (event.snapshot.value != null) {
        var user = new User.fromSnapshot(snapshot: event.snapshot);
        onData(user);
      } else {
        onData(null);
      }
    });

    return subscription;

  }

  Future addSpend(Spend spend) async {
    String month = DateFormat('MM').format(spend.dateTime);
    String year = DateFormat('yyyy').format(spend.dateTime);

    return fbDBRef
        .reference()
        .child("Spends")
        .child(uid)
        .child(year)
        .child(month)
        .push()
        .set(spend.toJson());
  }

  Future<StreamSubscription<Event>> getRecentRecords(void onData(SpendsList spendsList)) async {
    String month = DateFormat('MM').format(DateTime.now());
    String year = DateFormat('yyyy').format(DateTime.now());

    StreamSubscription<Event> subscription = fbDBRef
        .reference()
        .child("Spends")
        .child(uid)
        .child(year)
        .child(month)
        .onValue
        .listen((Event event) {
      if (event.snapshot.value != null) {
        var spends = new SpendsList.fromSnapshot(event.snapshot);
        onData(spends);
      } else {
        onData(null);
      }
    });

    return subscription;
  }

  Future<StreamSubscription<Event>> getSpendRecord(Spend payload,void onData(Spend spend)) async {

    String month = DateFormat('MM').format(payload.dateTime);
    String year = DateFormat('yyyy').format(payload.dateTime);

    StreamSubscription<Event> subscription = fbDBRef
        .reference()
        .child("Spends")
        .child(uid)
        .child(year)
        .child(month).child(payload.key)
        .onValue
        .listen((Event event) {
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
}
