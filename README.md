# pretty_qr_code

Pretty QR code for Flutter. You can round the edges with parameter or use the standard view.

## Features

* Created with [QR dart](https://github.com/kevmoo/qr.dart)

## Screenshots

  <img src="https://github.com/promops/flutter_pretty_qr/blob/master/images/Scr1.png" width="250"> 


## Example

```dart
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: PrettyQr(
                size: 200,
                data: '12423577',
                errorCorrectLevel: QrErrorCorrectLevel.M,
                roundEdges: true)),
      ),
    );
  }
}
```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.