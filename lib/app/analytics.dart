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
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.attach_money)),
              Tab(icon: Icon(Icons.pie_chart))
            ],
          ),
          title: Text('Analytics Spends',textAlign: TextAlign.center,),
          backgroundColor: Colors.lightBlue[900],
        ),
        body: TabBarView(
          children: [
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }

}