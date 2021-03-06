import 'package:chitragupta/app/home.dart';
import 'package:chitragupta/app/spends.dart';
import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../login.dart';

class AddTransactionScreen extends StatefulWidget {
  Spend spend;Repository repository;
  AddTransactionScreen(Repository repository, {this.spend}): repository = repository ?? Repository();
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState(oldSpend: spend,repository: repository);
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  Spend oldSpend;
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _spendController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  Repository repository;

  String spendTime;
  TimeOfDay time;
  DateTime dateTime;
  String selectedCat = "";
  String amountErrorTV, titleErrorTV, categoryErrorTV;
  bool _laoding = false;

  final globalKey = GlobalKey<ScaffoldState>();

  _AddTransactionScreenState({Spend oldSpend, Repository repository}):oldSpend=oldSpend,repository= repository ?? Repository();
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
      _dateController.text = spendTime;
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
          resizeToAvoidBottomPadding: true,
          key: globalKey,
          appBar: AppBar(
            title: Text("Add Transaction"),
            backgroundColor: Colors.lightBlue[900],
          ),
          body: Padding(
            padding: EdgeInsets.all(5),
            child: ListView(
              reverse: false,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: new TextField(
                    controller: this._amountController,
                    inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                    decoration: InputDecoration(
                        labelText: "Amount *",
                        prefixText: "???",
                        prefixIcon: Icon(Icons.monetization_on),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                        errorText: amountErrorTV),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: new TextField(
                    controller: this._spendController,
                    textCapitalization: TextCapitalization.sentences,
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
                      Text(categoryErrorTV,style: TextStyle(color: Colors.red),)
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
                    category("EMI"),
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
                    textCapitalization: TextCapitalization.sentences,
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
                  padding: EdgeInsets.all(5),
                  child:Container(
                    padding: EdgeInsets.all(5),
                    child: SvgPicture.asset(
                      getIcon(s),
                    ),
                    height: 20.0,
                    width: 20.0,
                  )
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
      spend.amount = double.parse(amount);
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
      print(err);
      final snackBar = SnackBar(
        content: Text('Something went wrong. Please try after some time.'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
      print(err);
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
    Fluttertoast.showToast(msg: 'Successfully Updated');
    Navigator.of(context).pop();
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
      print(err);
      globalKey.currentState.showSnackBar(snackBar);
    });
  }
}

String getIcon(String s) {
  String iconData = "assets/more.svg";
  switch (s) {
    case "Food":
      iconData = "assets/food.svg";
      break;
    case "Entertainment":
      iconData = "assets/entertainment.svg";
      break;
    case "Travel":
      iconData = "assets/travel.svg";
      break;
    case "EMI":
      iconData = "assets/emi.svg";
      break;
    case "Fuel":
      iconData = "assets/fuel.svg";
      break;
    case "Bills":
      iconData = "assets/bill.svg";
      break;
    case "Shopping":
      iconData = "assets/shopping.svg";
      break;
    case "Health":
      iconData = "assets/health.svg";
      break;
  }
  return iconData;
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
