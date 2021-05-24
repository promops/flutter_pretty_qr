import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

import 'pretty_qr_painter.dart';

class PrettyQr extends StatefulWidget {
  ///Widget size
  final double size;

  ///Qr code data
  final String data;

  ///Square color
  final Color elementColor;

  ///Error correct level
  final int errorCorrectLevel;

  ///Round the corners
  final bool roundEdges;

  ///Number of type generation (1 to 40 or null for auto)
  final int? typeNumber;

  final ImageProvider? image;

  PrettyQr(
      {Key? key,
      this.size = 100,
      required this.data,
      this.elementColor = Colors.black,
      this.errorCorrectLevel = QrErrorCorrectLevel.M,
      this.roundEdges = false,
      this.typeNumber,
      this.image})
      : super(key: key);

  @override
  _PrettyQrState createState() => _PrettyQrState();
}

class _PrettyQrState extends State<PrettyQr> {
  Future<ui.Image> _loadImage(BuildContext buildContext) async {
    final completer = Completer<ui.Image>();

    final stream = widget.image!.resolve(ImageConfiguration(
      devicePixelRatio: MediaQuery.of(buildContext).devicePixelRatio,
    ));

    stream.addListener(ImageStreamListener((imageInfo, error) {
      completer.complete(imageInfo.image);
    }, onError: (dynamic error, _) {
      completer.completeError(error);
    }));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return widget.image == null
        ? CustomPaint(
            size: Size(widget.size, widget.size),
            painter: PrettyQrCodePainter(
                data: widget.data,
                errorCorrectLevel: widget.errorCorrectLevel,
                elementColor: widget.elementColor,
                roundEdges: widget.roundEdges,
                typeNumber: widget.typeNumber),
          )
        : FutureBuilder(
            future: _loadImage(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: PrettyQrCodePainter(
                        image: snapshot.data,
                        data: widget.data,
                        errorCorrectLevel: widget.errorCorrectLevel,
                        elementColor: widget.elementColor,
                        roundEdges: widget.roundEdges,
                        typeNumber: widget.typeNumber),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
  }
}
