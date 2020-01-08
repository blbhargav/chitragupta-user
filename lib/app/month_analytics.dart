import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:chitragupta/models/budgetData.dart';
import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/repository.dart';
import 'package:chitragupta/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthAnalytics extends StatefulWidget {
  MonthAnalytics(Repository repository)
      : repository = repository ?? Repository();
  final Repository repository;
  @override
  _MonthAnalyticsState createState() => _MonthAnalyticsState(repository);
}

class _MonthAnalyticsState extends State<MonthAnalytics> {
  _MonthAnalyticsState(Repository repository)
      : repository = repository ?? Repository();
  Repository repository;

  List<charts.Series> todaySeriesList = new List();
  List<charts.Series> weekSeriesList = new List();
  List<charts.Series> weekBarSeriesList = new List();
  List<charts.Series> monthSeriesList = new List();

  double todayTotal;
  List<Spend> todaySpends;
  double weekTotal;
  List<Spend> weekSpends;
  double monthTotal;
  List<Spend> monthSpends;
  bool _loading;

  StreamSubscription _subscriptionTodo;
  var todayDate = new DateTime.now();
  var weekDate = DateTime.now().subtract(new Duration(days: 6));
  String month;
  BudgetData todayBudget, weekBudget, monthBudget;


  @override
  void initState() {
    super.initState();
    todaySpends = new List();
    weekSpends = new List();
    monthSpends = new List();

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
    if(spends==null){
      setState(() {
        _loading=false;
      });
      return;
    }
    var todayDate = new DateTime.now();
    var weekDate = todayDate.subtract(new Duration(days: 6));

    spends.sort((a, b) {
      var adate = a.dateTime;
      var bdate = b.dateTime;
      return adate.compareTo(bdate);
    });

    setState(() {
      todayTotal = 0;
      weekTotal = 0;
      monthTotal = 0;
      todaySpends.clear();
      weekSpends.clear();
      monthSpends.clear();
      todayBudget = new BudgetData();
      weekBudget = new BudgetData();
      monthBudget = new BudgetData();
      todaySeriesList.clear();
      weekSeriesList.clear();
      weekBarSeriesList.clear();
      monthSeriesList.clear();

      for (var spend in spends) {
        if (spend.dateTime.day == todayDate.day) {
          todayTotal += spend.amount;
          todaySpends.add(spend);
          switch (spend.category) {
            case "Food":
              todayBudget.food += spend.amount;
              break;
            case "Entertainment":
              todayBudget.entertainment += spend.amount;
              break;
            case "Travel":
              todayBudget.travel += spend.amount;
              break;
            case "EMI":
              todayBudget.emi += spend.amount;
              break;
            case "Fuel":
              todayBudget.fuel += spend.amount;
              break;
            case "Bills":
              todayBudget.bills += spend.amount;
              break;
            case "Shopping":
              todayBudget.shopping += spend.amount;
              break;
            case "Health":
              todayBudget.health += spend.amount;
              break;
            case "Others":
              todayBudget.others += spend.amount;
              break;
          }
        }
        if (spend.dateTime.isAfter(weekDate) &&
            spend.dateTime.isBefore(todayDate)) {
          weekTotal += spend.amount;
          weekSpends.add(spend);

          switch (spend.category) {
            case "Food":
              weekBudget.food += spend.amount;
              break;
            case "Entertainment":
              weekBudget.entertainment += spend.amount;
              break;
            case "Travel":
              weekBudget.travel += spend.amount;
              break;
            case "EMI":
              weekBudget.emi += spend.amount;
              break;
            case "Fuel":
              weekBudget.fuel += spend.amount;
              break;
            case "Bills":
              weekBudget.bills += spend.amount;
              break;
            case "Shopping":
              weekBudget.shopping += spend.amount;
              break;
            case "Health":
              weekBudget.health += spend.amount;
              break;
            case "Others":
              weekBudget.others += spend.amount;
              break;
          }
        }

        monthTotal += spend.amount;
        monthSpends.add(spend);

        switch (spend.category) {
          case "Food":
            monthBudget.food += spend.amount;
            break;
          case "Entertainment":
            monthBudget.entertainment += spend.amount;
            break;
          case "Travel":
            monthBudget.travel += spend.amount;
            break;
          case "EMI":
            monthBudget.emi += spend.amount;
            break;
          case "Fuel":
            monthBudget.fuel += spend.amount;
            break;
          case "Bills":
            monthBudget.bills += spend.amount;
            break;
          case "Shopping":
            monthBudget.shopping += spend.amount;
            break;
          case "Health":
            monthBudget.health += spend.amount;
            break;
          case "Others":
            monthBudget.others += spend.amount;
            break;
        }
      }

      //TodayBudget
      final todayData = [
        new LinearBudgets("Food", todayBudget.food),
        new LinearBudgets("Entertainment", todayBudget.entertainment),
        new LinearBudgets("Travel", todayBudget.travel),
        new LinearBudgets("EMI", todayBudget.emi),
        new LinearBudgets("Fuel", todayBudget.fuel),
        new LinearBudgets("Bills", todayBudget.bills),
        new LinearBudgets("Shopping", todayBudget.shopping),
        new LinearBudgets("Health", todayBudget.health),
        new LinearBudgets("Others", todayBudget.others),
      ];
      todaySeriesList = Utils.createPieData(todayData);


      //WeekBudget
      final weekData = [
        new LinearBudgets("Food", weekBudget.food),
        new LinearBudgets("Entertainment", weekBudget.entertainment),
        new LinearBudgets("Travel", weekBudget.travel),
        new LinearBudgets("EMI", weekBudget.emi),
        new LinearBudgets("Fuel", weekBudget.fuel),
        new LinearBudgets("Bills", weekBudget.bills),
        new LinearBudgets("Shopping", weekBudget.shopping),
        new LinearBudgets("Health", weekBudget.health),
        new LinearBudgets("Others", weekBudget.others),
      ];
      weekSeriesList = Utils.createPieData(weekData);

      WeeklyData weeklyData=new WeeklyData();
      for (var spend in weekSpends) {
        switch(DateFormat('EEEE').format(spend.dateTime)){
          case 'Sunday':weeklyData.sun+=spend.amount;break;
          case 'Monday':weeklyData.mon+=spend.amount;break;
          case 'Tuesday':weeklyData.tue+=spend.amount;break;
          case 'Wednesday':weeklyData.wed+=spend.amount;break;
          case 'Thursday':weeklyData.thu+=spend.amount;break;
          case 'Friday':weeklyData.fri+=spend.amount;break;
          case 'Saturday':weeklyData.sat+=spend.amount;break;
        }
      }
      List<LinearBudgets> weekBarData=List();
      for(var i=0;i<7;i++){
        var d=weekDate.add(new Duration(days: i));
        switch(DateFormat('EEEE').format(d)){
          case 'Sunday':weekBarData.add(new LinearBudgets("Sun", weeklyData.sun));break;
          case 'Monday':weekBarData.add(new LinearBudgets("Mon", weeklyData.mon));break;
          case 'Tuesday':weekBarData.add(new LinearBudgets("Tue", weeklyData.tue));break;
          case 'Wednesday':weekBarData.add(new LinearBudgets("Wed", weeklyData.wed));break;
          case 'Thursday':weekBarData.add(new LinearBudgets("Thu", weeklyData.thu));break;
          case 'Friday':weekBarData.add(new LinearBudgets("Fri", weeklyData.fri));break;
          case 'Saturday':weekBarData.add(new LinearBudgets("Sat", weeklyData.sat));break;
        }
      }
      weekBarSeriesList= Utils.createBarData(weekBarData);

      //MonthBudget
      final monthData = [
        new LinearBudgets("Food", monthBudget.food),
        new LinearBudgets("Entertainment", monthBudget.entertainment),
        new LinearBudgets("Travel", monthBudget.travel),
        new LinearBudgets("EMI", monthBudget.emi),
        new LinearBudgets("Fuel", monthBudget.fuel),
        new LinearBudgets("Bills", monthBudget.bills),
        new LinearBudgets("Shopping", monthBudget.shopping),
        new LinearBudgets("Health", monthBudget.health),
        new LinearBudgets("Others", monthBudget.others),
      ];
      monthSeriesList = Utils.createPieData(monthData);
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
                            Text("EMI"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${todayBudget.emi})",
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
        Padding(padding: EdgeInsets.all(2),),
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "This Week",
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
                              "(${weekBudget.food})",
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
                              "(${weekBudget.entertainment})",
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
                              "(${weekBudget.travel})",
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
                              "(${weekBudget.emi})",
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
                              "(${weekBudget.fuel})",
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
                              "(${weekBudget.bills})",
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
                              "(${weekBudget.shopping})",
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
                              "(${weekBudget.health})",
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
                              "(${weekBudget.others})",
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
                          child: charts.PieChart(weekSeriesList,
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
                                  "$weekTotal",
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
                    ),

                  ],
                ),

                Container(
                  width: double.maxFinite,
                  height: 200,
                  padding: EdgeInsets.only(top: 5),
                  child: charts.BarChart(
                    weekBarSeriesList,
                    animate: true,
                    barRendererDecorator: new charts.BarLabelDecorator<String>(),
                    domainAxis: new charts.OrdinalAxisSpec(),
                  ),
                ),


              ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.all(2),),
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "This ${DateFormat('MMMM').format(todayDate)}",
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
                              "(${weekBudget.food})",
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
                              "(${weekBudget.entertainment})",
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
                              "(${weekBudget.travel})",
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
                              "(${weekBudget.emi})",
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
                              "(${weekBudget.fuel})",
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
                              "(${weekBudget.bills})",
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
                              "(${weekBudget.shopping})",
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
                              "(${weekBudget.health})",
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
                              "(${weekBudget.others})",
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
                          child: charts.PieChart(weekSeriesList,
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
                                  "$monthTotal",
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
                    ),

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


