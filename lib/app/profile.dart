import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  var userName = "Jhon Appleseed";
  var email = "bhargavbl224gmail.com";
  var altId = "678 867 0388";
  var points = "380";

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

          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(userName,style: TextStyle(fontSize: 18),),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(email,style: TextStyle(fontSize: 18),),
                  ),


                ],
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Image.asset('assets/feather.png',height: 35,width: 35,),
        onPressed: () {

        },
      ),
    );
  }
}
