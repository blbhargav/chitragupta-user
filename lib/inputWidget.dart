import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final double topRight;
  final double bottomRight;
  final String label;
  InputWidget(this.topRight, this.bottomRight,this.label);


  @override
  _InputWidget createState() => _InputWidget(topRight,bottomRight,label);
}

class _InputWidget extends State<InputWidget>{
  final double topRight;
  final double bottomRight;
  final String label;
  _InputWidget(this.topRight, this.bottomRight,this.label);
  bool passwordVisible=false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(right: 40, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(bottomRight),
                  topRight: Radius.circular(topRight))),
          child: label.contains("Password")?Padding(
            padding: EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "",
                  hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14),
                  alignLabelWithHint: true,
                  labelText: label,
                  prefixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  )
              ),
              obscureText: !passwordVisible,

            )
          ):Padding(
              padding: EdgeInsets.only(left: 55, right: 10, top: 5, bottom: 5),
              child: TextField(
              decoration: InputDecoration(
              border: InputBorder.none,
                  hintText: "",
                  hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14),
                  alignLabelWithHint: true,
                  labelText: label
              ),

        ),
          ),
        ),
      ),
    );
  }

}
