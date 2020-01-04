import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text("About Chitragupta"),
          centerTitle: true,
          backgroundColor: Colors.lightBlue[900]),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Image.asset(
            "assets/logo.png",
            width: 180,
            height: 180,
          ),
          Padding(
            padding: EdgeInsets.all(2),
          ),
          Text(
            "Chitragupta is a expenditure tracker for students. This is a private project and not for business purpose. Since this project runs on free tier plan, the number of users are limited.",
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.start,
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Text(
              "'There is always a room for development'. Since this project is a baby, we welcome your inputs.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.start),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          Text("Incase of suggestion or problem, you knew whom to poke 😉.",
              style: TextStyle(fontSize: 18), textAlign: TextAlign.start),
        ],
      ),
    );
  }
}
