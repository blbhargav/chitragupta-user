import 'package:chitragupta/app/about.dart';
import 'package:chitragupta/app/changePassword.dart';
import 'package:chitragupta/app/profile.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../splash_screen.dart';

class Settings extends StatefulWidget {
  Settings(Repository repository): repository = repository ?? Repository();
  Repository repository;
  @override
  _settingsState createState() => _settingsState();
}
class _settingsState extends State<Settings>{
  var version='1.0.0';
  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),backgroundColor: Colors.lightBlue[900],centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[

          InkWell(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(5),
              child: Padding(
                child: Row(
                  children: <Widget>[
                    Image.asset("assets/user.png", width: 22,),Padding(padding: EdgeInsets.all(5),),
                    Text("Profile",style: TextStyle(fontSize: 18),)
                  ],
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(widget.repository)),
              );
            },
          ),

          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePassword(widget.repository)),
              );
            },
            child: Container(
              padding: EdgeInsets.only(left: 10,right: 10),
              margin: EdgeInsets.only(left: 5,right: 5),
              child: Padding(
                child: Row(
                  children: <Widget>[
                    Image.asset("assets/password.png", width: 20,),Padding(padding: EdgeInsets.all(5),),
                    Text("Change Password",style: TextStyle(fontSize: 18),)
                  ],
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),

          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUs()),
              );
            },
            child: Container(
              padding: EdgeInsets.only(left: 10,right: 10,top: 10),
              margin: EdgeInsets.only(left: 5,right: 5),
              child: Padding(
                child: Row(
                  children: <Widget>[
                    Image.asset("assets/about.png", width: 20,),Padding(padding: EdgeInsets.all(5),),
                    Text("About",style: TextStyle(fontSize: 18),)
                  ],
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),

          InkWell(
            onTap: (){showLogoutAlert();},
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(5),
              child: Padding(
                child: Row(
                  children: <Widget>[
                    Image.asset("assets/logout.png", width: 20,),Padding(padding: EdgeInsets.all(5),),
                    Text("Logout",style: TextStyle(fontSize: 18),)
                  ],
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
          ),

          Expanded(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text("Version $version"),
                )
            ),
          ),
        ],
      ),
    );
  }

  Future _logout() async {
    await widget.repository.signOut();
    await widget.repository.updateUserSignedLocally(false,"");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen(repository: widget.repository,)),
        ModalRoute.withName("/Splash"));
  }

  void showLogoutAlert() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            title: new Text("Are you sure to Logout?"),
            content: Text(""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Logout",style: TextStyle(fontSize: 18),),
                onPressed: () {
                  Navigator.of(context).pop();
                  _logout();
                },
              ),
              new FlatButton(
                child: new Text("No",style: TextStyle(fontSize: 18),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

}