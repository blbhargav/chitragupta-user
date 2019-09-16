import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class dashBoardScreen extends StatefulWidget {
  @override
  _dashBoardScreenState createState() => _dashBoardScreenState();
}
class _dashBoardScreenState extends State<dashBoardScreen>with TickerProviderStateMixin{
  String userName="Hi Bhargav";
  String currency="₹";
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
                  Colors.lightBlue[700],
                  Colors.lightBlue[500],
                  Colors.lightBlue[300],
                ],
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 50),),
                Text(userName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 19),),
                Padding(padding: EdgeInsets.all(15),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text("Yesterday"),
                            Padding(padding: EdgeInsets.all(5),),
                            Text("₹ 5"),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text("Today",style: TextStyle(fontSize: 20),),
                            Padding(padding: EdgeInsets.all(5),),
                            Text("₹ 5000",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text("Month"),
                            Padding(padding: EdgeInsets.all(5),),
                            Text("₹ 5"),
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
        onPressed: (){addTransactionPage();},
      ),
    );
  }

  void addTransactionPage() {

  }

}