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
  @protected
  late QrCode qrCode;

  @protected
  late PrettyQrDecoration beginDecoration;

  @protected
  late PrettyQrDecoration endDecoration;

  @override
  void initState() {
    super.initState();

    qrCode = QrCode(
      5,
      QrErrorCorrectLevel.H,
    )..addData(' ');

    beginDecoration = const PrettyQrDecoration(
      shape: PrettyQrRoundedRectangleModules(),
      image: PrettyQrDecorationImage(
        image: AssetImage('images/twitter.png'),
        scale: 0.2,
      ),
    );

    endDecoration = const PrettyQrDecoration(
      shape: PrettyQrRoundedRectangleModules(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      image: PrettyQrDecorationImage(
        image: AssetImage('images/twitter.png'),
        scale: 0.3,
      ),
    );
  }

  @protected
  void swapDecorations() {
    final decoration = beginDecoration;
    beginDecoration = endDecoration;
    endDecoration = decoration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox.square(
          dimension: 300,
          child: TweenAnimationBuilder<PrettyQrDecoration>(
            tween: PrettyQrDecorationTween(
              begin: beginDecoration,
              end: endDecoration,
            ),
            duration: const Duration(
              milliseconds: 240,
            ),
            onEnd: () => setState(() {
              // swapDecorations();
            }),
            builder: (context, decoration, child) {
              return GestureDetector(
                onTap: () => setState(() {
                  swapDecorations();
                }),
                child: PrettyQrView(
                  qrImage: QrImage(qrCode),
                  decoration: decoration,
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            qrCode.addData('X');
          });
        },
      ),
    );
  }
}
