import 'dart:async';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';

import 'app/dashboard.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, _checkUserHistory);
  }
  //Uses a Ticker Mixin for Animations
  Animation<double> _animation;
  AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    startTime();

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds:2)); //specify the duration for the animation & include `this` for the vsyc
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
        _animationController); //use Tween animation here, to animate between the values of 1.0 & 2.5.

    _animation.addListener(() {
      //here, a listener that rebuilds our widget tree when animation.value chnages
      setState(() {});
    });

    _animation.addStatusListener((status) {
      //AnimationStatus gives the current status of our animation, we want to go back to its previous state after completing its animation
      if (status == AnimationStatus.completed) {
        _animationController
            .reverse(); //reverse the animation back here if its completed
      }
    });
    _animationController.forward();
  }
  void _checkUserHistory() async {
    Repository repository=Repository();
    bool signedInLocal=await repository.isUserSignedLocally();
    bool signedInFirebase=await repository.isSignedIn();
    if(signedInFirebase && signedInLocal){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => dashBoardScreen()
          ),
          ModalRoute.withName("/Home")
      );
    }else{
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => loginRoot()
          ),
          ModalRoute.withName("/login")
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset('logo.png',height: 100* _animation.value,),
            new Text("BoutiquePlex",style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color:Colors.pink ),
            ),
            Container(
              child: new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink),
              ),
              margin: EdgeInsets.only(top: 50),
            ),
          ],
        ),
      ),
    );
  }
}

