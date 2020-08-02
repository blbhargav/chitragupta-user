import 'dart:async';

import 'package:chitragupta/app/addTransaction.dart';
import 'package:chitragupta/app/displayOrder.dart';
import 'package:chitragupta/app/displaySpend.dart';
import 'package:chitragupta/app/home.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/Product.dart';
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
  _dashBoardScreenState createState() => _dashBoardScreenState();
}

class _dashBoardScreenState extends State<dashBoardScreen>
    with TickerProviderStateMixin {

  String userName = "Hi Guest";
  String currency = "₹", noDataTV = "No Data Found";
  StreamSubscription _subscriptionTodo;
  List<Spend> recentSpends = new List();
  double today = 0, yesterday = 0, month = 0;
  bool _loading = true;
  List<Order> activeOrdersList = new List();
  @override
  void initState() {
    super.initState();
    userName = "Hi ${widget.repository.user.name}";
    getDataFromServer();
  }

  void getDataFromServer() {
    widget.repository.getActiveOrders().listen((event) async {
      List<Order> tempMonthOrdersList = new List();
      if (event.documents.length > 0) {
        for(int i=0;i<event.documents.length;i++){
          Order order=Order.fromSnapshot(snapshot: event.documents[i]);
          var products=await widget.repository.getProductsByEmployee(order.orderId);
          order.assignedItems.addAll(products);
          var procuredItems=0;
          if(order.assignedItems.length>0){
            order.assignedItems.forEach((element) {
                if(element.purchasedQty!=null && element.purchasedQty>0)
                  procuredItems++;
            });
          }
          order.procuredItems=procuredItems;
          tempMonthOrdersList.add(order);
        }
      }

      setState(() {
        activeOrdersList = tempMonthOrdersList;
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
                child: activeOrdersList.length <= 0
                    ? Center(
                        heightFactor: 20,
                        child: Text(noDataTV),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(5),
                        scrollDirection: Axis.vertical,
                        itemCount: activeOrdersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var pocuredColor=Colors.red[600];
                          if(activeOrdersList[index].totalItems==activeOrdersList[index].procuredItems){
                            pocuredColor=Colors.green[800];
                          }
                          return InkWell(
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "#${activeOrdersList[index].orderId}",
                                      style:
                                      TextStyle(color: Colors.black54,fontWeight: FontWeight.w400),
                                    ),
                                    Padding(padding: EdgeInsets.all(3),),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "${activeOrdersList[index].name}",
                                          style:
                                              TextStyle(color: Colors.black,fontWeight: FontWeight.w700),
                                        ),
                                        Text("${DateFormat("dd-MMM-yyyy").format(activeOrdersList[index].date)}",
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
                                                "${activeOrdersList[index].totalItems ?? 0}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                    color: Colors.blue[900])),
                                          ],
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              "Assigned Items",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(2),
                                            ),
                                            Text(
                                                "${(activeOrdersList[index].assignedItems.length)}",
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
                                                "${activeOrdersList[index].procuredItems ?? 0}",
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
                                MaterialPageRoute(builder: (context) => DisplayOrder(widget.repository,order:activeOrdersList[index],)),
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
      MaterialPageRoute(builder: (context) => AddTransactionScreen(widget.repository)),
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
            builder: (context) => DisplaySpendScreen(recentSpend, widget.repository)));
  }
}
