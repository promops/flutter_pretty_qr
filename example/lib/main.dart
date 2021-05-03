import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: PrettyQr(
                image: AssetImage('images/twitter.png'),
                typeNumber: 3,
                size: 300,
                data: 'https://www.google.ru',
                errorCorrectLevel: QrErrorCorrectLevel.M,
                roundEdges: true)));
  }
}
