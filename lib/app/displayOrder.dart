import 'package:chitragupta/app/home.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/Product.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DisplayOrder extends StatefulWidget {
  Order order;
  DisplayOrder(Repository repository, {this.order})
      : repository = repository ?? Repository();
  Repository repository;
  @override
  _DisplayOrderState createState() => _DisplayOrderState();
}

class _DisplayOrderState extends State<DisplayOrder> {
  bool _loading = false,_showSearchClearIcon=false;
  var pocuredColor = Colors.red[500];
  final List<Product> productsList = new List();
  List<Product> displayProductsList = new List();
  var totalSpent=0;
  TextEditingController _spareSearchControllers = TextEditingController();
  @override
  void initState() {
    super.initState();
    widget.repository.getOrderProducts(widget.order.orderId).listen((event) {
      List<Product> productS = new List();
      var procuredItems=0;
      var tempTotalSpent=0;
      if (event.documents.length > 0) {
        event.documents.forEach((element) {
          var product=Product.fromSnapshot(snapshot: element);
          if(product.purchasedQty!=null && product.purchasedQty>0)
            procuredItems++;
          if(product.amountSpent!=null && product.amountSpent>0)
            tempTotalSpent=tempTotalSpent+product.amountSpent;
          productS.add(product);
        });

        if(widget.order.assignedItems.length>0){
          widget.order.assignedItems.forEach((element) {
            if(element.purchasedQty!=null && element.purchasedQty>0)
              procuredItems++;
          });
        }
        widget.order.procuredItems=procuredItems;
      }
      setState(() {
        totalSpent=tempTotalSpent;
        widget.order.procuredItems=procuredItems;
        widget.order.assignedItems.clear();
        widget.order.assignedItems.addAll(productS);
        productsList.clear();
        productsList.addAll(productS);
        displayProductsList=productS;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.order.orderId}"),
          backgroundColor: Colors.blue[900],
        ),
        body: widget.order == null
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
                        "${widget.order.name}",
                        style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "${DateFormat("dd-MMM-yyyy").format(widget.order.date)}",
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
                            "Assigned Items",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                          ),
                          Text("${widget.order.assignedItems.length}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.blue[900])),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Total Amount Spent",
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
                          Text("${widget.order.procuredItems ?? 0}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: pocuredColor)),
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1, //
                        color: Colors.grey,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                          Radius.circular(
                              15.0) //         <--- border radius here
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.search),
                      title: TextField(
                        controller: _spareSearchControllers,
                        decoration: InputDecoration(
                            hintText: 'Search Product', border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ),
                      trailing: _showSearchClearIcon? IconButton(icon:  Icon(Icons.cancel), onPressed: () {
                        _spareSearchControllers.clear();
                        onSearchTextChanged('');
                      },):null,
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
                                  color: Colors.black12,
                                  height: 1,
                                );
                              },
                              padding: EdgeInsets.all(5),
                              scrollDirection: Axis.vertical,
                              itemCount: displayProductsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Product product = displayProductsList[index];
                                var purchasedColor = Colors.red[500];
                                if (product.purchaseQty == product.purchasedQty) {
                                  purchasedColor = Colors.green[500];
                                }
                                return InkWell(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        bottom: 10,
                                        top: 10,
                                        left: 10,
                                        right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${product.product}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  "Expected Qty",
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.black45),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 2),
                                                ),
                                                Text(
                                                  "${product.purchaseQty ?? 0}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      fontSize: 15,
                                                      color:
                                                      Colors.blue[900]),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  "Amount Spent",
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.black45),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 2),
                                                ),
                                                Text(
                                                  "₹ ${product.amountSpent ?? 0}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      color: Colors.green),
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
                                                  "${product.purchasedQty ?? 0}",
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
                                  onTap: () {
                                    showEditProductAlertDialog(context, product);
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
              width: MediaQuery.of(contxt).size.width/0.9,
              padding:
                  EdgeInsets.only(top: 10, right: 15, bottom: 10, left: 15),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    "${product.product}",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10,bottom: 10),
                    child: Row(
                      children: [
                        Text("Expected Purchase Qty : ",style: TextStyle(color: Colors.black54,fontSize: 12),),
                        Text("${product.purchaseQty ?? 0}",style: TextStyle(fontWeight: FontWeight.w700),)
                       ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._purchaseQtyController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
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
                    padding: EdgeInsets.all(10),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._purchaseAmountController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
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
                    padding: EdgeInsets.all(10),
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
                        widget.repository.updatePurchaseQuantity(widget.order.orderId, product.id,pQty, amountSpent);
                        setState(() {
                          _loading=false;
                        });
                        _purchaseAmountController.text="";
                        _purchaseQtyController.text="";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Center(
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Cancel",style: TextStyle(color: Colors.black54),),
                      ),
                      onTap: (){
                        Navigator.pop(context);
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
  void onSearchTextChanged(String text) {
    List<Product> tempProductsData=List();
    displayProductsList.clear();
    if (text.isEmpty) {
      tempProductsData.addAll(productsList);
    }else{
      productsList.forEach((product) {
        if (product.product.toLowerCase().contains(text.toLowerCase())){
          tempProductsData.add(product);
        }
      });
    }
    setState(() {
      _showSearchClearIcon=text.isNotEmpty;
      displayProductsList.addAll(tempProductsData);
    });
  }
}
