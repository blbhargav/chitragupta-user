import 'package:chitragupta/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => {
  runApp(MyApp())
};

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.pink),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {

  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //*************Strings Used***************
  static String _title = "Chitragupta";

  @override
  Widget build(BuildContext context) {
    return new SplashScreen();
  }
}