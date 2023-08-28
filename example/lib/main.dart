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
  late QrCode _qr;

  @override
  void initState() {
    _qr = QrCode(
      4,
      QrErrorCorrectLevel.M,
    )..addData('https://www.');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: Кэш
      //TODO: Передавать ли размер

      body: Center(
        child: Container(
          height: 300,
          width: 300,
          child: PrettyQrView(
            decoration: const PrettyQrDecoration(
              image: PrettyQrDecorationImage(
                image: AssetImage('images/twitter.png'),
                scale: 0.2,
              ),
              color: Colors.black,
              // shape: PrettyQrDefaultDots(),
              shape: PrettyQrPrettyDots(
                roundFactor: 1,
              ),
            ),
            qrImage: QrImage(_qr),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _qr.addData('xxss');
          });
        },
      ),
    );
  }
}
