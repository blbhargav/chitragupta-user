import 'dart:async';

import 'package:chitragupta/app/addTransaction.dart';
import 'package:chitragupta/app/displayOrder.dart';
import 'package:chitragupta/app/displaySpend.dart';
import 'package:chitragupta/app/home.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/models/user.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chitragupta/globals.dart' as globals;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class dashBoardScreen extends StatefulWidget {
  Repository repository;
  dashBoardScreen(Repository repository)
      : repository = repository ?? Repository();

  @override
  _dashBoardScreenState createState() => _dashBoardScreenState(repository);
}

class _dashBoardScreenState extends State<dashBoardScreen>
    with TickerProviderStateMixin {
  _dashBoardScreenState(Repository repository)
      : repository = repository ?? Repository();

  String userName = "Hi Guest";
  String currency = "₹", noDataTV = "No Data Found";
  StreamSubscription _subscriptionTodo;
  List<Spend> recentSpends = new List();
  double today = 0, yesterday = 0, month = 0;
  bool _loading = true;
  Repository repository;
  List<Order> monthOrdersList = new List();
  @override
  void initState() {
    super.initState();

    if (HomeScreenState.user == null) {
      repository.getUserProfile().then((res) {
        User user = (User.fromSnapshot(snapshot: res));
        HomeScreenState.user = user;
        setState(() {
          userName = "Hi ${user.name}";
        });
        getDataFromServer();
      });
    } else {
      getDataFromServer();
    }
  }

  void getDataFromServer() {
    repository.getActiveOrders().listen((event) {
      List<Order> tempMonthOrdersList = new List();
      if (event.documents.length > 0) {
        event.documents.forEach((element) {
          tempMonthOrdersList.add(Order.fromSnapshot(snapshot: element));
        });
      }
      setState(() {
        monthOrdersList = tempMonthOrdersList;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          title: Text("$userName"),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: FractionalOffset.bottomCenter,
              padding: EdgeInsets.only(top: 20, bottom: 8),
              child: Text(
                "Active Orders",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18),
              ),
            ),
            Expanded(
              child: Container(
                child: monthOrdersList.length <= 0
                    ? Center(
                        heightFactor: 20,
                        child: Text(noDataTV),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(5),
                        scrollDirection: Axis.vertical,
                        itemCount: monthOrdersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var pocuredColor=Colors.red[600];
                          if(monthOrdersList[index].totalItems==monthOrdersList[index].procuredItems){
                            pocuredColor=Colors.green[800];
                          }
                          return InkWell(
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "#${monthOrdersList[index].orderId}",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        Text(
                                            "${DateFormat("dd-MMM-yyyy").format(monthOrdersList[index].date)}",
                                        style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.w700),)
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              "Total Items",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2),
                                            ),
                                            Text(
                                                "${monthOrdersList[index].totalItems ?? 0}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                    color: Colors.blue[900])),
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              "Procured Items",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2),
                                            ),
                                            Text(
                                                "${monthOrdersList[index].procuredItems ?? 0}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                    color: pocuredColor)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DisplayOrder(repository,orderId:monthOrdersList[index].orderId,)),
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      inAsyncCall: _loading,
      opacity: 0.3,
    );
  }

  void addTransactionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTransactionScreen(repository)),
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplaySpendScreen(recentSpend, repository)));
  }
}
