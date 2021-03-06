import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:chitragupta/models/budgetData.dart';
import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/repository.dart';
import 'package:chitragupta/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class AllAnalytics extends StatefulWidget {
  AllAnalytics(Repository repository)
      : repository = repository ?? Repository();
  final Repository repository;
  @override
  _AllAnalyticsState createState() => _AllAnalyticsState(repository);
}

class _AllAnalyticsState extends State<AllAnalytics>{
  _AllAnalyticsState(Repository repository)
      : repository = repository ?? Repository();
  Repository repository;
  StreamSubscription _subscriptionTodo;
  bool _loading;
  List<Spend> yearSpends;
  var todayDate = new DateTime.now();
  BudgetData yearlyBudget;
  double totalAmount=0;
  List<charts.Series> yearSeriesList = new List();
  @override
  void initState() {
    super.initState();
    yearSpends=new List();
    _loading=true;


    repository
        .getAllSpendRecords( _updateUI)
        .then((StreamSubscription s) => _subscriptionTodo = s)
        .catchError((err) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_loading) {
      return Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (yearSpends.length <= 0) {
      return Center(
        child: Container(
          child: Text("No Data Found"),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(5),
      children: <Widget>[
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                Text(
//                  "",
//                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                ),
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 10,
                              height: 10,
                              color: Color(0xff91CCF5),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text("Food"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${yearlyBudget.food})",
                              style: TextStyle(
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 10,
                              height: 10,
                              color: Color(0xffFEAB93),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text("Entertainment"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${yearlyBudget.entertainment})",
                              style: TextStyle(
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 10,
                              height: 10,
                              color: Color(0xffE0F1A0),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text("Travel"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${yearlyBudget.travel})",
                              style: TextStyle(
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 10,
                              height: 10,
                              color: Color(0xff80CBC5),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text("EMI"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${yearlyBudget.emi})",
                              style: TextStyle(
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 10,
                              height: 10,
                              color: Color(0xffFFEB3C),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text("Fuel"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${yearlyBudget.fuel})",
                              style: TextStyle(
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 10,
                              height: 10,
                              color: Color(0xff3F51B5),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text("Bills"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${yearlyBudget.bills})",
                              style: TextStyle(
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 10,
                              height: 10,
                              color: Color(0xFFF190B1),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text("Shopping"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${yearlyBudget.shopping})",
                              style: TextStyle(
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 10,
                              height: 10,
                              color: Color(0xff4DB04E),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text("Health"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${yearlyBudget.health})",
                              style: TextStyle(
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(2),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 10,
                              height: 10,
                              color: Color(0xff9C27B3),
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text("Others"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${yearlyBudget.others})",
                              style: TextStyle(
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            )
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          child: charts.PieChart(yearSeriesList,
                              animate: true,
                              animationDuration: Duration(milliseconds: 500),
                              // Configure the width of the pie slices to 60px. The remaining space in
                              // the chart will be left as a hole in the center.
                              defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 25,
                              )),
                          height: 180,
                          width: 180,
                        ),
                        Container(
                          height: 180,
                          width: 180,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Total Spent",
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Text(
                                  "$totalAmount",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );


  }
  @override
  void dispose() {
    if (_subscriptionTodo != null) {
      _subscriptionTodo.cancel();
    }
    super.dispose();
  }

  void _updateUI(List<Spend> spends) {
    setState(() {
      if(spends==null){
        _loading=false;
        return;
      }
      yearlyBudget=new BudgetData();
      totalAmount=0;
      for (var spend in spends) {
        totalAmount+=spend.amount;
        switch (spend.category) {
          case "Food":
            yearlyBudget.food += spend.amount;
            break;
          case "Entertainment":
            yearlyBudget.entertainment += spend.amount;
            break;
          case "Travel":
            yearlyBudget.travel += spend.amount;
            break;
          case "EMI":
            yearlyBudget.emi += spend.amount;
            break;
          case "Fuel":
            yearlyBudget.fuel += spend.amount;
            break;
          case "Bills":
            yearlyBudget.bills += spend.amount;
            break;
          case "Shopping":
            yearlyBudget.shopping += spend.amount;
            break;
          case "Health":
            yearlyBudget.health += spend.amount;
            break;
          case "Others":
            yearlyBudget.others += spend.amount;
            break;
        }

      }

      final yearData = [
        new LinearBudgets("Food", yearlyBudget.food),
        new LinearBudgets("Entertainment", yearlyBudget.entertainment),
        new LinearBudgets("Travel", yearlyBudget.travel),
        new LinearBudgets("EMI", yearlyBudget.emi),
        new LinearBudgets("Fuel", yearlyBudget.fuel),
        new LinearBudgets("Bills", yearlyBudget.bills),
        new LinearBudgets("Shopping", yearlyBudget.shopping),
        new LinearBudgets("Health", yearlyBudget.health),
        new LinearBudgets("Others", yearlyBudget.others),
      ];
      yearSeriesList = Utils.createPieData(yearData);

      yearSpends.addAll(spends);

      _loading=false;
    });
  }

}