import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';

class Analytics extends StatefulWidget {
  Analytics(Repository repository):repository=repository??Repository();
  Repository repository;
  @override
  _analyticsState createState() => _analyticsState(repository);
}
class _analyticsState extends State<Analytics>{
  _analyticsState(Repository repository):repository=repository??Repository();
  Repository repository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spends"),backgroundColor: Colors.lightBlue[900],centerTitle: true,
      ),
      body: Center(
        child: Text("Analytics"),
      ),
    );
  }

}