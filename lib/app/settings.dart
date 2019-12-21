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
  _settingsState createState() => _settingsState(repository);
}
class _settingsState extends State<Settings>{
  Repository repository;
  var version='1.0.0';

  _settingsState(Repository repository): repository = repository ?? Repository();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
    });
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
                MaterialPageRoute(builder: (context) => Profile(repository)),
              );
            },
          ),

          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePassword(repository)),
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
            onTap: (){},
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
    await repository.signOut();
    await repository.updateUserSignedLocally(false,"");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
        ModalRoute.withName("/Splash"));
  }

  void showLogoutAlert() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Are you sure to Logout?"),
            content: Text(""),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Logout"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _logout();
                },
              ),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

}