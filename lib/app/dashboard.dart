import 'dart:async';

import 'package:chitragupta/app/addTransaction.dart';
import 'package:chitragupta/app/displaySpend.dart';
import 'package:chitragupta/models.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chitragupta/globals.dart' as globals;
import 'package:intl/intl.dart';

class dashBoardScreen extends StatefulWidget {
  @override
  _dashBoardScreenState createState() => _dashBoardScreenState();
}

class _dashBoardScreenState extends State<dashBoardScreen>
    with TickerProviderStateMixin {
  String userName = "Hi Bhargav";
  String currency = "₹";
  StreamSubscription _subscriptionTodo;
  List<Spend> recentSpends = new List();
  int today = 0, yesterday = 0, month = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Repository repository = new Repository();
    repository
        .getRecentRecords(_updateRecentSpends)
        .then((StreamSubscription s) => _subscriptionTodo = s);
  }

  _updateRecentSpends(SpendsList spendsList) {
    List<Spend> spendList = spendsList.spendList;
    List<Spend> tempRecentSpends = new List();
    int tempToday = 0, tempYesterday = 0, tempMonth = 0;

    spendList.sort((a, b) {
      var adate = a.dateTime;
      var bdate = b.dateTime;
      return -adate.compareTo(bdate);
    });
    var currentDate = DateTime.now();
    var yesterdayDate =
        new DateTime(currentDate.year, currentDate.month, currentDate.day - 1);

    spendList.forEach((spend) {
      int i = 0;
      if (i < 20) {
        i++;
        tempRecentSpends.add(spend);
      }
      String todayDate = DateFormat('dd-MM-yyyy').format(currentDate);
      String yesterdayDateString =
          DateFormat('dd-MM-yyyy').format(yesterdayDate);

      if (todayDate == DateFormat('dd-MM-yyyy').format(spend.dateTime)) {
        tempToday += spend.amount;
      } else if (yesterdayDateString ==
          DateFormat('dd-MM-yyyy').format(spend.dateTime)) {
        tempYesterday += spend.amount;
      }

      tempMonth += spend.amount;
    });

    setState(() {
      recentSpends = tempRecentSpends;
      today = tempToday;
      yesterday = tempYesterday;
      month = tempMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Colors.lightBlue[900],
                  Colors.lightBlue[900],
                  Colors.lightBlue[900],
                  Colors.lightBlue[900],
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                ),
                Text(
                  userName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Yesterday",
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Text("₹ ${yesterday}",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Today",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Text("₹ ${today}",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text("Month",
                                style: TextStyle(color: Colors.white)),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Text("₹ ${month}",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              "Recent Spends This Month",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue,fontSize: 18),
            ),
          ),
          Container(
            child: recentSpends.length <= 0
                ? Center(
                    heightFactor: 20,
                    child: Text("No spends in this month yet"),
                  )
                : Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(5),
                      scrollDirection: Axis.vertical,
                      itemCount: recentSpends.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    PhysicalModel(
                                      borderRadius:
                                      new BorderRadius.circular(25.0),
                                      color: Colors.white,
                                      child: new Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: new BoxDecoration(
                                          borderRadius:
                                          new BorderRadius.circular(25.0),
                                          border: new Border.all(
                                            width: 1.0,
                                            color: Colors.cyan,
                                          ),
                                        ),
                                        child: Icon(getIcon(
                                            recentSpends[index].category)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          recentSpends[index].title,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                        ),
                                        Text("#${recentSpends[index].category}",style: TextStyle(fontStyle: FontStyle.italic),),

                                        Padding(
                                          padding: EdgeInsets.only(top: 5),
                                        ),
                                        Text(
                                          DateFormat('dd-MM-yyyy hh:mm a').format(
                                              recentSpends[index].dateTime),
                                          style: TextStyle(color: Colors.black45),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: Text(
                                        "₹ ${recentSpends[index].amount}",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 18),
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
                          onTap: (){
                            navigateToDisplaySpend(recentSpends[index]);
                          },
                          onDoubleTap: (){
                            navigateToDisplaySpend(recentSpends[index]);
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addTransactionPage();
        },
      ),
    );
  }

  void addTransactionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTransactionScreen()),
    );
  }

  @override
  void dispose() {
    if (_subscriptionTodo != null) {
      _subscriptionTodo.cancel();
    }
    super.dispose();
  }

  void navigateToDisplaySpend(Spend recentSpend) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DisplaySpendScreen(recentSpend)));
  }
}
