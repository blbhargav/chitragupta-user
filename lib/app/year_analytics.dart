import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:chitragupta/models/budgetData.dart';
import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/repository.dart';
import 'package:chitragupta/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class YearAnalytics extends StatefulWidget {
  YearAnalytics(Repository repository)
      : repository = repository ?? Repository();
  final Repository repository;
  @override
  _YearAnalyticsState createState() => _YearAnalyticsState(repository);
}

class _YearAnalyticsState extends State<YearAnalytics>{
  _YearAnalyticsState(Repository repository)
      : repository = repository ?? Repository();
  Repository repository;
  StreamSubscription _subscriptionTodo;
  bool _loading;
  List<Spend> yearSpends;
  var todayDate = new DateTime.now();
  BudgetData yearlyBudget;

  int totalAmount=0;
  List<charts.Series> yearSeriesList = new List();
  List<charts.Series> yearBarSeriesList = new List();
  @override
  void initState() {
    super.initState();
    yearSpends=new List();
    _loading=true;

    repository
        .getYearlyListRecords("${todayDate.year}", _updateUI)
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
                Text(
                  "This ${DateFormat('yyyy').format(todayDate)}",
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
                            Text("Snacks"),
                            Padding(
                              padding: EdgeInsets.all(3),
                            ),
                            Text(
                              "(${yearlyBudget.snacks})",
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
                    ),

                  ],
                ),

                Container(
                  width: double.maxFinite,
                  height: 200,
                  padding: EdgeInsets.only(top: 5),
                  child: charts.BarChart(
                    yearBarSeriesList,
                    animate: true,
                    //barRendererDecorator: new charts.BarLabelDecorator<String>(),
                    //domainAxis: new charts.OrdinalAxisSpec(),
                  ),

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
      YearlyData yearlyData=new YearlyData();
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
          case "Snacks":
            yearlyBudget.snacks += spend.amount;
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
        switch(spend.dateTime.month){
          case 1:yearlyData.jan+=spend.amount;break;
          case 2:yearlyData.feb+=spend.amount;break;
          case 3:yearlyData.mar+=spend.amount;break;
          case 4:yearlyData.apr+=spend.amount;break;
          case 5:yearlyData.may+=spend.amount;break;
          case 6:yearlyData.jun+=spend.amount;break;
          case 7:yearlyData.jul+=spend.amount;break;
          case 8:yearlyData.aug+=spend.amount;break;
          case 9:yearlyData.sep+=spend.amount;break;
          case 10:yearlyData.oct+=spend.amount;break;
          case 11:yearlyData.nov+=spend.amount;break;
          case 12:yearlyData.dec+=spend.amount;break;
        }

      }

      final yearData = [
        new LinearBudgets("Food", yearlyBudget.food),
        new LinearBudgets("Entertainment", yearlyBudget.entertainment),
        new LinearBudgets("Travel", yearlyBudget.travel),
        new LinearBudgets("Snacks", yearlyBudget.snacks),
        new LinearBudgets("Fuel", yearlyBudget.fuel),
        new LinearBudgets("Bills", yearlyBudget.bills),
        new LinearBudgets("Shopping", yearlyBudget.shopping),
        new LinearBudgets("Health", yearlyBudget.health),
        new LinearBudgets("Others", yearlyBudget.others),
      ];
      yearSeriesList = Utils.createPieData(yearData);

      List<LinearBudgets> yearBarData=List();
      for(var i=1;i<=12;i++){
        switch(i){
          case 1:yearBarData.add(new LinearBudgets("Jan", yearlyData.jan));break;
          case 2:yearBarData.add(new LinearBudgets("Feb", yearlyData.feb));break;
          case 3:yearBarData.add(new LinearBudgets("Mar", yearlyData.mar));break;
          case 4:yearBarData.add(new LinearBudgets("Apr", yearlyData.apr));break;
          case 5:yearBarData.add(new LinearBudgets("May", yearlyData.may));break;
          case 6:yearBarData.add(new LinearBudgets("Jun", yearlyData.jun));break;
          case 7:yearBarData.add(new LinearBudgets("Jul", yearlyData.jul));break;
          case 8:yearBarData.add(new LinearBudgets("Aug", yearlyData.aug));break;
          case 9:yearBarData.add(new LinearBudgets("Sep", yearlyData.sep));break;
          case 10:yearBarData.add(new LinearBudgets("Oct", yearlyData.oct));break;
          case 11:yearBarData.add(new LinearBudgets("Nov", yearlyData.nov));break;
          case 12:yearBarData.add(new LinearBudgets("Dec", yearlyData.dec));break;
        }
      }
      yearBarSeriesList= Utils.createBarDataWithoutLabels(yearBarData);

      yearSpends.addAll(spends);

      _loading=false;
    });
  }

}