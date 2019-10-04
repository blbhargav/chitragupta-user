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
    FirebaseUser user=await _firebaseAuth.currentUser();
    uid=user.uid;
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

 Future<List<Map<dynamic, dynamic>>> getRecentSpends()  async{
//    QuerySnapshot querySnapshot = await Firestore.instance.collection("Spends").document(Repository.uid).collection("10-2019").getDocuments();
//    print("BLB ${querySnapshot.documentChanges}");
//    var list = querySnapshot.documents;
//    return list;
   List<DocumentSnapshot> templist;
   List<Map<dynamic, dynamic>> list = new List();
    var path=Firestore.instance.collection("Spends").document(uid).collection("10-2019");

    var collectionSnapshot=await path.getDocuments();
    print("BLB collection ${collectionSnapshot}");
   templist = collectionSnapshot.documents;
   print("BLB templist ${templist.length}");
   list = templist.map((DocumentSnapshot docSnapshot){
     return docSnapshot.data;
   }).toList();

   return list;
  }


}