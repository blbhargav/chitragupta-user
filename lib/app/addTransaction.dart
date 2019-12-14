import 'package:chitragupta/app/home.dart';
import 'package:chitragupta/app/spends.dart';
import 'package:chitragupta/models.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../login.dart';

class AddTransactionScreen extends StatefulWidget {
  Spend spend;
  AddTransactionScreen({this.spend});
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState(oldSpend: spend);
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  Spend oldSpend;
  _AddTransactionScreenState({this.oldSpend});
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _spendController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  Repository repository = new Repository();

  String spendTime;
  TimeOfDay time;
  DateTime dateTime;
  String selectedCat = "";
  String amountErrorTV, titleErrorTV, categoryErrorTV;
  bool _laoding = false;

  final globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    spendTime = DateFormat('dd-MM-yyyy hh:mm a').format(now);
    _dateController.text = spendTime;
    time = TimeOfDay.now();
    dateTime = DateTime.now();

    if(oldSpend!=null){
      _amountController.text="${oldSpend.amount}";
      _spendController.text=oldSpend.title;
      if(oldSpend.description.isNotEmpty)
        _descriptionController.text=oldSpend.description;

      spendTime=DateFormat('dd-MM-yyyy hh:mm a').format(oldSpend.dateTime);
      dateTime=oldSpend.dateTime;
      time=TimeOfDay.fromDateTime(dateTime);
      selectedCat=oldSpend.category;
    }
  }

  List<Color> saveGradient = [
    Color(0xFF0EDED2),
    Color(0xFF03A0FE),
  ];
  @override
  Widget build(BuildContext context) {
    int countRow;
    double width = MediaQuery.of(context).size.width;
    int widthCard = 75;
    countRow = width ~/ widthCard;

    return ProgressHUD(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          key: globalKey,
          appBar: AppBar(
            title: Text("Add Transaction"),
            backgroundColor: Colors.lightBlue[900],
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: ListView(
                reverse: false,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._amountController,
                      decoration: InputDecoration(
                          labelText: "Amount *",
                          prefixText: "₹",
                          prefixIcon: Icon(Icons.monetization_on),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          errorText: amountErrorTV),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._spendController,
                      decoration: InputDecoration(
                          labelText: "What is this spend for? *",
                          prefixIcon: Icon(Icons.info),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          errorText: titleErrorTV),
                      maxLength: 50,
                      maxLengthEnforced: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._dateController,
                      decoration: InputDecoration(
                        labelText: "Date-Time *",
                        prefixIcon: Icon(Icons.date_range),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                      enableInteractiveSelection: false,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        showDateTimePicker();
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10)),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16,top: 20),
                      ),
                      Icon(Icons.category),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                      ),
                      Text("Category *"),
                      if (categoryErrorTV != null && categoryErrorTV.length > 0)
                        Text(categoryErrorTV)
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    primary: true,
                    physics: new NeverScrollableScrollPhysics(),
                    crossAxisCount: countRow,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    children: <Widget>[
                      category("Food"),
                      category("Entertainment"),
                      category("Travel"),
                      category("Snacks"),
                      category("Fuel"),
                      category("Bills"),
                      category("Shopping"),
                      category("Health"),
                      category("Others"),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",
                        prefixIcon: Icon(Icons.description),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                      maxLength: 100,
                      maxLengthEnforced: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  GestureDetector(
                    child: Center(
                      child: roundedRectButton("Save", saveGradient, false),
                    ),
                    onTap: () {
                      validate(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        opacity: 0.5,
        inAsyncCall: _laoding);
  }

  void showDateTimePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2018, 3, 5),
        maxTime: DateTime.now(), onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      dateTime = date;
      _selectTime(context);
    }, currentTime: dateTime, locale: LocaleType.en);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay response = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (response != null && response != time) {
      time = response;
      dateTime = DateTime(
          dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
      _dateController.text = DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
    }
  }

  category(String s) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: <Widget>[
            PhysicalModel(
              borderRadius: new BorderRadius.circular(25.0),
              color: selectedCat.length <= 0
                  ? Colors.white
                  : (selectedCat.contains(s) ? Colors.blue : Colors.white),
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
                child: Icon(getIcon(s)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
            ),
            Text(
              s,
              style: TextStyle(fontSize: 11),
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          selectedCat = s;
        });
      },
    );
  }

  void validate(BuildContext context) {
    String amount = _amountController.text;
    String title = _spendController.text;
    String category = selectedCat;
    String date = DateFormat('dd-MM-yyyy').format(dateTime);
    String description = _descriptionController.text;
    //print("BLB ${DateTime.now().toIso8601String()}");

    setState(() {
      amountErrorTV = null;
      categoryErrorTV = null;
      titleErrorTV = null;
    });

    if (amount.isEmpty) {
      setState(() {
        amountErrorTV = "Please enter this field";
      });
    } else if (title.isEmpty) {
      setState(() {
        titleErrorTV = "Please enter this field";
      });
    } else if (category.isEmpty) {
      setState(() {
        categoryErrorTV = "Please select one category";
      });
    } else {
      Spend spend = new Spend();
      spend.amount = int.parse(amount);
      spend.category = category;
      spend.dateTime = dateTime;
      spend.title = title;
      spend.description = description;

      if(oldSpend!=null){
        updateSpend(context,spend);
      }else{
        saveInDB(context, spend);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _amountController.dispose();
    _spendController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
  }

  void saveInDB(BuildContext context, Spend spend) {
    showProgress();
    repository.addSpend(spend).then((res) {
      hideProgress();
      setState(() {
        _amountController.clear();
        _spendController.clear();
        //_dateController.clear();
        _descriptionController.clear();
      });
      final snackBar = SnackBar(
        content: Text('Successfully Added'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
      globalKey.currentState.showSnackBar(snackBar);

      //Navigator.pop(context);
    }).catchError((err) {
      hideProgress();
      final snackBar = SnackBar(
        content: Text('Something went wrong. Please try after some time.'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
      globalKey.currentState.showSnackBar(snackBar);
    });
  }

  showProgress() {
    setState(() {
      _laoding = true;
    });
  }

  hideProgress() {
    setState(() {
      _laoding = false;
    });
  }
  void showSuccessMessage() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => homeScreen()
                ),
                ModalRoute.withName("/Home")
            );
          });
          return AlertDialog(
            title: Text('Successfully Updated',),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok',style: TextStyle(color: Colors.green,fontSize: 18),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => homeScreen()
                      ),
                      ModalRoute.withName("/Home")
                  );
                },
              ),
            ],
          );
        });
  }
  void updateSpend(BuildContext context, Spend spend) {
    showProgress();
    repository.updateSpend(oldSpend,spend).then((res) {
      hideProgress();
      setState(() {
        _amountController.clear();
        _spendController.clear();
        //_dateController.clear();
        _descriptionController.clear();
      });
      showSuccessMessage();

      //Navigator.pop(context);
    }).catchError((err) {
      hideProgress();
      final snackBar = SnackBar(
        content: Text('Something went wrong. Please try after some time.'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
      globalKey.currentState.showSnackBar(snackBar);
    });
  }
}

IconData getIcon(String s) {
  IconData iconData = Icons.more;
  switch (s) {
    case "Food":
      iconData = Icons.restaurant;
      break;
    case "Entertainment":
      iconData = Icons.play_arrow;
      break;
    case "Travel":
      iconData = Icons.card_travel;
      break;
    case "Snacks":
      iconData = Icons.fastfood;
      break;
    case "Fuel":
      iconData = Icons.local_gas_station;
      break;
    case "Bills":
      iconData = Icons.receipt;
      break;
    case "Shopping":
      iconData = Icons.shopping_cart;
      break;
    case "Health":
      iconData = Icons.healing;
      break;
  }
  return iconData;
}
