import 'package:flutter/material.dart';

class dashBoardScreen extends StatefulWidget {
  @override
  _dashBoardScreenState createState() => _dashBoardScreenState();
}
class _dashBoardScreenState extends State<dashBoardScreen>with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Dashboard"),
      ),
    );
  }

}