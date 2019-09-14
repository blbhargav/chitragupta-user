import 'package:chitragupta/background.dart';
import 'package:chitragupta/inputWidget.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';

class loginRoot extends StatefulWidget {
  @override
  _loginRootState createState() => _loginRootState();
}
class _loginRootState extends State<loginRoot>with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Background(),
            Login(),
          ],
        )
    );
  }

}
class Login extends StatefulWidget {
  TextEditingController _userIdController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  @override
  _Login createState() => _Login(_userIdController,_passwordController);
}

class _Login extends State<Login>{
  TextEditingController _userIdController,_passwordController;

  _Login(this._userIdController, this._passwordController);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
        ),
        Column(
          children: <Widget>[
            ///holds email header and inputField
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 40, bottom: 10),
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    InputWidget(30.0, 0.0,"Email",_userIdController),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    InputWidgetPassword(30.0, 0.0,"Password",_passwordController),
                    Padding(
                        padding: EdgeInsets.only(right: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  gradient: LinearGradient(
                                      colors: signInGradients,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                ),
                                child: ImageIcon(
                                  AssetImage("assets/ic_forward.png"),
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: (){
                                Repository repository=new Repository();
                                repository.signInWithCredentials(_userIdController.text, _passwordController.text)
                                  .then((res){
                                      print("BLB $res");
                                  })
                                  .catchError((e){
                                  print("BLB $res");
                                });
                              },
                            )
                          ],
                        ))
                  ],
                ),
              ],
            ),
            Text("Forgot password?",style: TextStyle(color: Colors.lightBlueAccent,fontStyle: FontStyle.italic,decoration: TextDecoration.underline),),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
            ),
            Text("New user?"),
            Padding(padding: EdgeInsets.all(2),),
            //roundedRectButton("Let's get Started", signInGradients, false),
            roundedRectButton("Create an Account", signUpGradients, false),
          ],
        )
      ],
    );
  }
}
Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible) {
  return Builder(builder: (BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment(1.0, 0.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(mContext).size.width / 1.7,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            padding: EdgeInsets.only(top: 16, bottom: 16),
          ),
          Visibility(
            visible: isEndIconVisible,
            child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageIcon(
                  AssetImage("assets/ic_forward.png"),
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  });
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];