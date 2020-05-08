import 'package:chitragupta/app/home.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/Product.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DisplayOrder extends StatefulWidget {
  String orderId;
  DisplayOrder(Repository repository, {this.orderId})
      : repository = repository ?? Repository();
  Repository repository;
  @override
  _DisplayOrderState createState() => _DisplayOrderState();
}

class _DisplayOrderState extends State<DisplayOrder> {
  bool _loading = false;
  Order order;
  var pocuredColor = Colors.red[500];
  List<Product> productsList = new List();
  var totalSpent=0;
  @override
  void initState() {
    super.initState();
    widget.repository.getOrder(widget.orderId).listen((event) {
      setState(() {
        _loading = false;
        order = Order.fromSnapshot(snapshot: event);
        if (order.totalItems == order.procuredItems) {
          pocuredColor = Colors.green[500];
        }
        if(event.data["${HomeScreenState.user.uid}"]!=null){
          totalSpent=event.data[HomeScreenState.user.uid];
        }
      });
    });

    widget.repository.getOrderProducts(widget.orderId).listen((event) {
      List<Product> productS = new List();
      if (event.documents.length > 0) {
        event.documents.forEach((element) {
          productS.add(Product.fromSnapshot(snapshot: element));
        });
      }
      setState(() {
        productsList = productS;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.orderId}"),
          backgroundColor: Colors.blue[900],
        ),
        body: order == null
            ? Center(
                child: Text("No Data Found"),
              )
            : ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Created @ ${DateFormat("dd-MMM-yyyy").format(order.createdDate)}",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                      Text(
                        "${DateFormat("dd-MMM-yyyy").format(order.date)}",
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Total Items",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                          ),
                          Text("${order.totalItems ?? 0}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.blue[900])),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Amount Spent",
                            style:
                            TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                          ),
                          Text("₹ ${totalSpent}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 19,
                                  color: Colors.blue[900])),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Procured Items",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                          ),
                          Text("${order.procuredItems ?? 0}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: pocuredColor)),
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text(
                    "Items List",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue[900]),
                  ),
                  TextField(
                    //controller: this._oldController,
                    decoration: InputDecoration(
                        hintText: "Search Item by name",
                        prefixIcon: Icon(Icons.search),
                        suffix: GestureDetector(child:Icon(Icons.cancel),onTap: (){

                        },),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                        //errorText: oldErrorTV
                    ),
                  ),
                  productsList.length == 0
                      ? Container(
                          height: 200,
                          child: Center(
                            child: Text("No data found"),
                          ),
                        )
                      : Container(
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  margin: EdgeInsets.only(top: 2, bottom: 2),
                                  width: MediaQuery.of(context).size.width,
                                  height: 1,
                                );
                              },
                              padding: EdgeInsets.all(5),
                              scrollDirection: Axis.vertical,
                              itemCount: productsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Product product = productsList[index];
                                var purchasedColor = Colors.red[500];
                                if (product.POQty == product.purchasedQty) {
                                  purchasedColor = Colors.green[500];
                                }
                                return GestureDetector(
                                  child: Card(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: 10,
                                          top: 10,
                                          left: 10,
                                          right: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "${product.description}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16),
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Total Order",
                                                    style: TextStyle(
                                                        fontSize: 8,
                                                        color: Colors.black45),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 2),
                                                  ),
                                                  Text(
                                                    "${product.POQty}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Colors.blue[900]),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Payer",
                                                    style: TextStyle(
                                                        fontSize: 8,
                                                        color: Colors.black45),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 2),
                                                  ),
                                                  Text(
                                                    "${product.payer ?? "-"}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Colors.blue[900]),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    "Purchased",
                                                    style: TextStyle(
                                                        fontSize: 8,
                                                        color: Colors.black45),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 2),
                                                  ),
                                                  Text(
                                                    "${product.purchasedQty}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: purchasedColor),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showEditProductAlertDialog(
                                        context, product);
                                  },
                                );
                              }),
                        ),
                ],
              ),
      ),
      inAsyncCall: _loading,
      opacity: 0.4,
    );
  }
  var _purchaseQtyController=TextEditingController();
  var _purchaseAmountController=TextEditingController();
  String _purchaseQuantityErrorTV,_purchaseAmountErorTV;
  showEditProductAlertDialog(BuildContext contxt, Product product) {
    return showDialog(
        context: contxt,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 500.0,
              padding:
                  EdgeInsets.only(top: 10, right: 15, bottom: 10, left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "${product.description}",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._purchaseQtyController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Purchased Quantity",
                        prefixIcon: Icon(Icons.info),
                        errorText: _purchaseQuantityErrorTV,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._purchaseAmountController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Amount Spent",
                        prefixIcon: Icon(MdiIcons.currencyInr),
                        errorText: _purchaseAmountErorTV,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        "Update",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      color: Colors.lightBlue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () async {
                        _purchaseQuantityErrorTV=null;
                        _purchaseAmountErorTV=null;
                        Navigator.pop(context);
                        if(_purchaseQtyController.text.isEmpty){
                          _purchaseQuantityErrorTV="Please enter Purchased Quantity";
                          showEditProductAlertDialog(contxt,product);
                          return;
                        }
                        if(_purchaseAmountController.text.isEmpty){
                          _purchaseAmountErorTV="Please enter Amount Spent";
                          showEditProductAlertDialog(contxt,product);
                          return;
                        }
                        setState(() {
                          _loading=true;
                        });
                        int pQty=int.parse(_purchaseQtyController.text);
                        int amountSpent=int.parse(_purchaseAmountController.text);
                        widget.repository.updatePurchaseQuantity(widget.orderId, product.id,pQty, amountSpent);
                        setState(() {
                          _loading=false;
                        });
                        _purchaseAmountController.text="";
                        _purchaseQtyController.text="";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
