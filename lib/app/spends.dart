import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:chitragupta/app/addTransaction.dart';
import 'package:chitragupta/app/displaySpend.dart';
import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Spends extends StatefulWidget {
  Repository repository;
  Spends(Repository repository) : repository = repository ?? Repository();

  @override
  _spendsState createState() => _spendsState(repository);
}

class _spendsState extends State<Spends> {
  bool _laoding = true;
  Repository repository;
  StreamSubscription _subscriptionTodo;
  _spendsState(Repository repository) : repository = repository ?? Repository();

  List<SpendsList> yearlySpends = new List();
  List<int> months = new List();
  String noDataTV = "", title = "Spends";
  var groupValue="",year;

  List<String> years=new List();

  @override
  void initState() {
    super.initState();
    DateTime dateTime = DateTime.now();
    year = DateFormat('yyyy').format(dateTime);
    title = "Spends - $year";
    repository
        .getYearlyRecords(year, _updateRecords)
        .then((StreamSubscription s) => _subscriptionTodo = s)
        .catchError((err) {
      setState(() {
        _laoding = false;
      });
    });
    years.add(DateFormat('yyyy').format(DateTime.now()));
    groupValue=DateFormat('yyyy').format(DateTime.now());

    repository.getSpendYears().then((res){
      years.clear();
      Map<String, dynamic> decoded = json.decode(res.body);
      for (var colour in decoded.keys) {
        years.add(colour);
      }
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.lightBlue[900],
        centerTitle: true,
      ),
      body: ProgressHUD(
        opacity: 0.3,
        inAsyncCall: _laoding,
        child: yearlySpends.length <= 0
            ? Center(
                heightFactor: 20,
                child: Text(noDataTV),
              )
            : Container(
                margin: EdgeInsets.all(5),
                child: ListView.builder(
                  itemCount: months.length,
                  itemBuilder: (context, i) {
                    return new ExpansionTile(
                      title: new Text(
                        "${getMonthName(months[i])}",
                        style: new TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      initiallyExpanded: i==(months.length-1),
                      children: <Widget>[
                        new Column(
                          children: _buildExpandableContent(yearlySpends[i]),
                        ),
                      ],
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_list),
        onPressed: () {
          _yearsBottomSheet(context);
        },
      ),
    );
  }

  void _yearsBottomSheet(context){
    showModalBottomSheet(
        context: context,elevation: 2,
        builder: (BuildContext bc){
          return Container(
            height: MediaQuery.of(context).size.height/2,
            child: new ListView.builder(
              itemCount: years.length,
              itemBuilder: (BuildContext context, int index) {
                return RadioListTile(
                  title: new Text("${years[index]}"),
                  value: years[index],
                  groupValue: groupValue,
                  onChanged: (value){
                    Navigator.of(context).pop();
                    setState(() {
                      year=value;
                      title = "Spends - $year";
                    });
                    groupValue=value;
                    refreshData();
                  },
                  activeColor: Colors.lightBlue[900],
                );
              },

            ),
          );
        }
    );
  }

  void _updateRecords(List<int> months, List<SpendsList> spendList) {
    yearlySpends.clear();
    setState(() {
      _laoding = false;
      if (months != null) {
        yearlySpends = spendList;
        this.months = months;
      } else
        noDataTV = "No Data Found";
    });
  }

  _buildExpandableContent(SpendsList monthSpends) {
    List<Widget> columnContent = [];

    for (Spend spend in monthSpends.spendList)
      columnContent.add(InkWell(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  PhysicalModel(
                    borderRadius: new BorderRadius.circular(25.0),
                    color: Colors.white,
                    child: new Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(25.0),
                        border: new Border.all(
                          width: 1.0,
                          color: Colors.cyan,
                        ),
                      ),
                      child: Icon(getIcon(spend.category)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          spend.title,
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          "#${spend.category}",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          DateFormat('dd-MMM-yyyy hh:mm a')
                              .format(spend.dateTime),
                          style: TextStyle(color: Colors.black45),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "₹ ${spend.amount}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
              new Divider(
                color: Colors.black12,
              )
            ],
          ),
        ),
        onTap: () {
          navigateToDisplaySpend(spend);
        },
        onDoubleTap: () {
          navigateToDisplaySpend(spend);
        },
      ));

    return columnContent;
  }

  getMonthName(int month) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return months[month - 1];
  }

  void navigateToDisplaySpend(Spend recentSpend) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplaySpendScreen(recentSpend, repository)));
  }

  void refreshData() {
    if (_subscriptionTodo != null) {
      _subscriptionTodo.cancel();
    }

    repository
        .getYearlyRecords(year, _updateRecords)
        .then((StreamSubscription s) => _subscriptionTodo = s)
        .catchError((err) {
      setState(() {
        _laoding = false;
      });
    });
  }
}
