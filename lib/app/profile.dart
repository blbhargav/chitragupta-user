import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.lightBlue[900],
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(5),),
          Stack(
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/profile.png'),
                      fit: BoxFit.fitHeight
                  ),
                ),
              ),
              Container(
                height: 200,
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              Container(
                height: 200,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 25,left: 20),
                child: Center(
                  child: CircleAvatar(
                    child: Image.asset('assets/user_avatar.png'),
                    maxRadius: 75,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
