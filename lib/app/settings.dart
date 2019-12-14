import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _settingsState createState() => _settingsState();
}
class _settingsState extends State<Settings>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),backgroundColor: Colors.lightBlue[900],centerTitle: true,
      ),
      body: Center(
        child: Text("Settings"),
      ),
    );
  }

}