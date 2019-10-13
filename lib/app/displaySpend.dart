import 'package:chitragupta/app/addTransaction.dart';
import 'package:chitragupta/models.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DisplaySpendScreen extends StatefulWidget {
  Spend spend;
  DisplaySpendScreen(Spend spend) : this.spend = spend;

  @override
  _DisplaySpendState createState() => new _DisplaySpendState(spend);
}

class _DisplaySpendState extends State<DisplaySpendScreen> {
  bool _loading = false;
  Spend spend;

  _DisplaySpendState(Spend spend) : this.spend = spend;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Spend"),
            backgroundColor: Colors.lightBlue[900],
            actions: <Widget>[
              InkWell(
                child: Icon(
                  Icons.delete,
                ),
                onTap: (){
                  showDeleteAlert();
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
            ],
          ),
          body: ListView(
            children: <Widget>[
              Container(
                height: 120,
                color: Colors.lightBlue[900],
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text("#${spend.category}",style: TextStyle(color: Colors.white),),
                        Padding(padding: EdgeInsets.all(5),),
                        Text("₹ ${spend.amount}",style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold)),
                        Padding(padding: EdgeInsets.all(5),),
                        Expanded(
                          child: Text("${DateFormat('dd-MMMM-yyyy hh:mm a').format(spend.dateTime)}",style: TextStyle(color: Colors.white),),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              
              Padding(padding: EdgeInsets.all(5),),

              Text("${spend.title}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),

              Padding(
                padding: EdgeInsets.all(5),
                child: Text("${spend.description}"),
              )

            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              navigateToEditSpendPage();
            },
          ),
        ),
        opacity: 0.5,
        inAsyncCall: _loading);
  }

  Future<void> showDeleteAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to delete this spend?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Deleting will permenatly remove this spend transaction from database.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No',style: TextStyle(color: Colors.green),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('DELETE',style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
                deleteSpend();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteSpend() {
    Repository repository=new Repository();
    setState(() {
      _loading=true;
    });
    repository.deleteSpend(spend).then((res){
      setState(() {
        _loading=false;
      });
      showSuccessMessage();
    }).catchError((err){
      setState(() {
        _loading=false;
      });
    });
  }

  void showSuccessMessage() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
            Navigator.pop(context);
          });
          return AlertDialog(
            title: Text('Successfully deleted',),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok',style: TextStyle(color: Colors.green,fontSize: 18),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void navigateToEditSpendPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTransactionScreen(spend: spend,)));
  }
}
