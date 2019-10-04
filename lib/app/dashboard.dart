import 'package:chitragupta/app/addTransaction.dart';
import 'package:chitragupta/models.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class dashBoardScreen extends StatefulWidget {
  @override
  _dashBoardScreenState createState() => _dashBoardScreenState();
}

class _dashBoardScreenState extends State<dashBoardScreen>
    with TickerProviderStateMixin {
  String userName = "Hi Bhargav";
  String currency = "₹";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Repository repository=new Repository();
    repository.getUserId();
    repository.getRecentSpends().then((res){
      print("BLB result${res}");
    }).catchError((e){
      print("BLB error $e");
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
                            Text("₹ 5", style: TextStyle(color: Colors.white)),
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
                            Text("₹ 5000",
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
                            Text("₹ 5", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
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
}
