import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';

class Spends extends StatefulWidget {
  Repository repository;
  Spends(Repository repository):repository=repository??Repository();

  @override
  _spendsState createState() => _spendsState(repository);
}
class _spendsState extends State<Spends>{
  bool _laoding=false;
  Repository repository;
  _spendsState(Repository repository):repository=repository??Repository();
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
      body: ProgressHUD(
        opacity: 0.3,
        inAsyncCall: _laoding,
        child: Center(
          child: Text("Spends"),
        ),
      ),
    );
  }

}