import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:chitragupta/models/budgetData.dart';
import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthAnalytics extends StatefulWidget {
  MonthAnalytics(Repository repository)
      : repository = repository ?? Repository();
  Repository repository;
  @override
  _MonthAnalyticsState createState() => _MonthAnalyticsState(repository);
}

class _MonthAnalyticsState extends State<MonthAnalytics> {
  _MonthAnalyticsState(Repository repository)
      : repository = repository ?? Repository();
  Repository repository;

  List<charts.Series> todaySeriesList=new List();

  int todayTotal;
  List<Spend> todaySpends;
  int weekTotal;
  List<Spend> weekSpends;
  int monthTotal;
  List<Spend> monthSpends;
  bool _loading;
  int food,
      entertainment,
      travel,
      snacks,
      fuel,
      bills,
      shopping,
      health,
      others;
  StreamSubscription _subscriptionTodo;
  var todayDate = new DateTime.now();
  var weekDate = DateTime.now().subtract(new Duration(days: 6));
  String month;
  BudgetData todayBudget, weekBudget, monthBudget;

  final foodColor = charts.MaterialPalette.blue.makeShades(2)[1];
  final entertainColor = charts.MaterialPalette.deepOrange.makeShades(2)[1];
  final travelColor = charts.MaterialPalette.lime.makeShades(2)[1];
  final snacksColor = charts.MaterialPalette.teal.makeShades(2)[1];
  final fuelColor = charts.MaterialPalette.yellow.makeShades(2)[2];
  final billsColor = charts.MaterialPalette.indigo.makeShades(2)[2];
  final shoppingColor = charts.MaterialPalette.pink.makeShades(2)[1];
  final healthColor = charts.MaterialPalette.green.makeShades(2)[2];
  final otherColor = charts.MaterialPalette.purple.makeShades(2)[2];

  @override
  void initState() {
    super.initState();
    todaySpends = new List();
    weekSpends = new List();
    monthSpends = new List();

    todayBudget = new BudgetData();
    weekBudget = new BudgetData();
    monthBudget = new BudgetData();

    todayTotal = 0;
    weekTotal = 0;
    monthTotal = 0;

    _loading = true;

    month = todayDate.month.toString();
    if (month.length == 1) {
      month = "0$month";
    }

    repository
        .getMonthlyRecords("${todayDate.year}", "${month}", _updateUI)
        .then((StreamSubscription s) => _subscriptionTodo = s)
        .catchError((err) {
      setState(() {
        _loading = false;
      });
    });
  }

  void _updateUI(List<Spend> spends) {
    var todayDate = new DateTime.now();
    var weekDate = todayDate.subtract(new Duration(days: 6));

    setState(() {
      todayTotal = 0;
      weekTotal = 0;
      monthTotal = 0;
      todaySpends.clear();
      weekSpends.clear();
      monthSpends.clear();
      for (var spend in spends) {
        if (spend.dateTime.day == todayDate.day) {
          todayTotal += spend.amount;
          todaySpends.add(spend);
          switch(spend.category){
            case "Food": todayBudget.food+=spend.amount;break;
            case "Entertainment": todayBudget.entertainment+=spend.amount;break;
            case "Travel": todayBudget.travel+=spend.amount;break;
            case "Snacks": todayBudget.snacks+=spend.amount;break;
            case "Fuel": todayBudget.fuel+=spend.amount;break;
            case "Bills": todayBudget.bills+=spend.amount;break;
            case "Shopping": todayBudget.shopping+=spend.amount;break;
            case "Health": todayBudget.health+=spend.amount;break;
            case "Others": todayBudget.others+=spend.amount;break;
          }
        }
        if (spend.dateTime.isAfter(weekDate) &&
            spend.dateTime.isBefore(todayDate)) {
          weekTotal += spend.amount;
          weekSpends.add(spend);

          switch(spend.category){
            case "Food": weekBudget.food+=spend.amount;break;
            case "Entertainment": weekBudget.entertainment+=spend.amount;break;
            case "Travel": weekBudget.travel+=spend.amount;break;
            case "Snacks": weekBudget.snacks+=spend.amount;break;
            case "Fuel": weekBudget.fuel+=spend.amount;break;
            case "Bills": weekBudget.bills+=spend.amount;break;
            case "Shopping": weekBudget.shopping+=spend.amount;break;
            case "Health": weekBudget.health+=spend.amount;break;
            case "Others": weekBudget.others+=spend.amount;break;
          }
        }

        monthTotal += 0;
        monthSpends.add(spend);

        switch(spend.category){
          case "Food": monthBudget.food+=spend.amount;break;
          case "Entertainment": monthBudget.entertainment+=spend.amount;break;
          case "Travel": monthBudget.travel+=spend.amount;break;
          case "Snacks": monthBudget.snacks+=spend.amount;break;
          case "Fuel": monthBudget.fuel+=spend.amount;break;
          case "Bills": monthBudget.bills+=spend.amount;break;
          case "Shopping": monthBudget.shopping+=spend.amount;break;
          case "Health": monthBudget.health+=spend.amount;break;
          case "Others": monthBudget.others+=spend.amount;break;
        }
      }

      //TodayBudget
      final todayData = [
        new LinearBudgets("Food", todayBudget.food),
        new LinearBudgets("Entertainment", todayBudget.entertainment),
        new LinearBudgets("Travel", todayBudget.travel),
        new LinearBudgets("Snacks", todayBudget.snacks),
        new LinearBudgets("Fuel", todayBudget.fuel),
        new LinearBudgets("Bills", todayBudget.bills),
        new LinearBudgets("Shopping", todayBudget.shopping),
        new LinearBudgets("Health", todayBudget.health),
        new LinearBudgets("Others", todayBudget.others),
      ];
      todaySeriesList=[new charts.Series<LinearBudgets, String>(
        id: 'Sales',
        domainFn: (LinearBudgets sales, _) => sales.budget,
        measureFn: (LinearBudgets sales, _) => sales.amount,
        data: todayData,
        colorFn: (LinearBudgets sales, _) {
          switch (sales.budget ){
          case "Food": return foodColor;
          case "Entertainment": return entertainColor;
          case "Travel": return travelColor;
          case "Snacks": return snacksColor;
          case "Fuel": return fuelColor;
          case "Bills": return billsColor;
          case "Shopping": return shoppingColor;
          case "Health": return healthColor;
          case "Others": return otherColor;
          }
        },
        labelAccessorFn: (LinearBudgets row, _) => '${row.budget}: ${row.amount}',
      )];

      _loading = false;
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
    } else if (monthSpends.length <= 0) {
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
                Text(
                  "Today",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text("Food"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${todayBudget.food})",
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
                              "(${todayBudget.entertainment})",
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
                              "(${todayBudget.travel})",
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
                            Text("Snacks"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${todayBudget.snacks})",
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
                              "(${todayBudget.fuel})",
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
                              "(${todayBudget.bills})",
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
                              "(${todayBudget.shopping})",
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
                              "(${todayBudget.health})",
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
                              "(${todayBudget.others})",
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
                          child: charts.PieChart(todaySeriesList,
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
                                  "$todayTotal",
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
}

class LinearBudgets {
  final String budget;
  final int amount;

  LinearBudgets(this.budget, this.amount);
}
