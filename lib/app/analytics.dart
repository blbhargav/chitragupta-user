import 'dart:async';

import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Analytics extends StatefulWidget {
  Analytics(Repository repository):repository=repository??Repository();
  Repository repository;
  @override
  _analyticsState createState() => _analyticsState(repository);
}
class _analyticsState extends State<Analytics>{
  _analyticsState(Repository repository):repository=repository??Repository();
  Repository repository;
  StreamSubscription _subscriptionTodo;
  List<Spend> spendsList;
  List<charts.Series> seriesList;
  @override
  void initState() {
    super.initState();
    spendsList=new List();
    repository
        .getAllSpendRecords(_updateUI)
        .then((StreamSubscription s) => _subscriptionTodo = s)
        .catchError((err) {});

  }

  @override
  void dispose() {
    if (_subscriptionTodo != null) {
      _subscriptionTodo.cancel();
    }
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Analytics',textAlign: TextAlign.center,),centerTitle: true,
          backgroundColor: Colors.lightBlue[900],
        ),
        body:spendsList.length>0? ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            Card(
              elevation: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Today",style: TextStyle(fontSize: 18),),
                  Stack(
                    children: <Widget>[
//                      charts.PieChart(
//                        _project.getExpensesToChartSeries(),
//                        animate: true,
//                        animationDuration: Duration(milliseconds: 500),
//                        selectionModels: [
//                          new charts.SelectionModelConfig(
//                            type: charts.SelectionModelType.info,
//                            //changedListener: _onSelectionChanged,
//                          )
//                        ],
//                        defaultRenderer: charts.ArcRendererConfig(
//                          arcWidth: 25,
//                        ),
//                      ),
                      Center(
                        child: Text(
                          "88%",
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  )


                ],
              ),
            ),

          ],
        ):Center(child: Text("No Data Found"),),
      ),
    );
  }


  void _updateUI(List<Spend> spends) {
    List<Spend> todaySpends=new List();
    List<Spend> weekSpends=new List();
    List<Spend> monthSpends=new List();
    List<Spend> yearSpends=new List();

//    setState(() {
//      spendsList.clear();
//      spendsList.addAll(spends);
//    });
  }
}