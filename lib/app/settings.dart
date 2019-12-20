import 'package:chitragupta/app/changePassword.dart';
import 'package:chitragupta/app/profile.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../splash_screen.dart';

class Settings extends StatefulWidget {
  @override
  _settingsState createState() => _settingsState();
}
class _settingsState extends State<Settings>{
  var version='1.0.0';
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
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),

          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePassword()),
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
            onTap: (){_logout();},
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
    Repository repository=Repository();
    await repository.signOut();
    await repository.updateUserSignedLocally(false,"");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
        ModalRoute.withName("/Splash"));
  }

}