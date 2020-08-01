import 'package:chitragupta/app/analytics.dart';
import 'package:chitragupta/app/dashboard.dart';
import 'package:chitragupta/app/settings.dart';
import 'package:chitragupta/app/spends.dart';
import 'package:chitragupta/models/user.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class homeScreen extends StatefulWidget {
  homeScreen(Repository repository) : repository = repository ?? Repository();
  Repository repository;

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<homeScreen> with TickerProviderStateMixin {
  var _selectedIndex = 0;
  DateTime currentBackPressTime;
  static User user;
  @override
  void initState() {
    super.initState();
    widget.repository.getUserId();

    widget.repository.getUserProfile().then((res){
      user=User.fromSnapshot(snapshot: res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: _selectedIndex == 0
            ? dashBoardScreen(
          widget.repository,
              )
            : (_selectedIndex == 1
                ? Spends(widget.repository)
                : (_selectedIndex == 2
                    ? Settings(widget.repository)
                    : Settings(widget.repository))),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightBlue[900],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              title: Text('Spends'),
            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.insert_chart),
//              title: Text('Analytics'),
//            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
      onWillPop: () async {
        if (_selectedIndex > 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        } else {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(msg: "Press again to exist.");
            return Future.value(false);
          }
          return Future.value(true);
        }
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];
