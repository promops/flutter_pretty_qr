import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

class PrettyQrCodePainter extends CustomPainter {
  final String data;
  final Color elementColor;
  final int errorCorrectLevel;
  final int typeNumber;
  final bool roundEdges;
  ui.Image image;
  QrCode _qrCode;
  int deletePixelCount = 0;

  PrettyQrCodePainter(
      {this.data,
      this.elementColor = Colors.black,
      this.errorCorrectLevel = QrErrorCorrectLevel.M,
      this.roundEdges = false,
      this.typeNumber = 1,
      this.image}) {
    _qrCode = QrCode(typeNumber, errorCorrectLevel);
    _qrCode.addData(data);
    _qrCode.make();
  }

  @override
  paint(Canvas canvas, Size size) {
    if (image != null) {
      if (this.typeNumber <= 2) {
        deletePixelCount = this.typeNumber + 7;
      } else if (this.typeNumber <= 4) {
        deletePixelCount = this.typeNumber + 8;
      } else {
        deletePixelCount = this.typeNumber + 9;
      }

      var imageSize = Size(image.width.toDouble(), image.height.toDouble());

      var src = Alignment.center.inscribe(imageSize,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));

      var dst = Alignment.center.inscribe(
          Size(size.height / 4, size.height / 4),
          Rect.fromLTWH(size.width / 3, size.height / 3, size.height / 3,
              size.height / 3));

      canvas.drawImageRect(image, src, dst, Paint());
    }

    roundEdges ? _paintRound(canvas, size) : _paintDefault(canvas, size);
  }

  void _paintRound(Canvas canvas, Size size) {
    var _paint = Paint()
      ..style = PaintingStyle.fill
      ..color = this.elementColor
      ..isAntiAlias = true;

    var _paintBackground = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white
      ..isAntiAlias = true;

    List<List> matrix = List<List>(_qrCode.moduleCount + 2);
    for (var i = 0; i < _qrCode.moduleCount + 2; i++) {
      matrix[i] = List(_qrCode.moduleCount + 2);
    }

    for (int x = 0; x < _qrCode.moduleCount + 2; x++) {
      for (int y = 0; y < _qrCode.moduleCount + 2; y++) {
        matrix[x][y] = false;
      }
    }

    for (int x = 0; x < _qrCode.moduleCount; x++) {
      for (int y = 0; y < _qrCode.moduleCount; y++) {
        if (image != null &&
            x >= deletePixelCount &&
            y >= deletePixelCount &&
            x < _qrCode.moduleCount - deletePixelCount &&
            y < _qrCode.moduleCount - deletePixelCount) {
          matrix[y + 1][x + 1] = false;
          continue;
        }

        if (_qrCode.isDark(y, x)) {
          matrix[y + 1][x + 1] = true;
        } else {
          matrix[y + 1][x + 1] = false;
        }
      }
    }

    double pixelSize = size.width / _qrCode.moduleCount;

    for (int x = 0; x < _qrCode.moduleCount; x++) {
      for (int y = 0; y < _qrCode.moduleCount; y++) {
        if (matrix[y + 1][x + 1]) {
          final Rect squareRect =
              Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize);

          _setShape(x + 1, y + 1, squareRect, _paint, matrix, canvas,
              _qrCode.moduleCount);
        } else {
          _setShapeInner(
              x + 1, y + 1, _paintBackground, matrix, canvas, pixelSize);
        }
      }
    }
  }

  void _drawCurve(Offset p1, Offset p2, Offset p3, Canvas canvas) {
    Path path = Path();

    path.moveTo(p1.dx, p1.dy);
    path.quadraticBezierTo(p2.dx, p2.dy, p3.dx, p3.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p1.dx, p1.dy);
    path.close();

    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = this.elementColor);
  }

  //Скругляем внутренние углы (фоновым цветом)
  void _setShapeInner(
      int x, int y, Paint paint, List matrix, Canvas canvas, double pixelSize) {
    double widthY = pixelSize * (y - 1);
    double heightX = pixelSize * (x - 1);

    //bottom right check
    if (matrix[y + 1][x] && matrix[y][x + 1] && matrix[y + 1][x + 1]) {
      Offset p1 =
          Offset(heightX + pixelSize - (0.25 * pixelSize), widthY + pixelSize);
      Offset p2 = Offset(heightX + pixelSize, widthY + pixelSize);
      Offset p3 =
          Offset(heightX + pixelSize, widthY + pixelSize - (0.25 * pixelSize));

      _drawCurve(p1, p2, p3, canvas);
    }

    //top left check
    if (matrix[y - 1][x] && matrix[y][x - 1] && matrix[y - 1][x - 1]) {
      Offset p1 = Offset(heightX, widthY + (0.25 * pixelSize));
      Offset p2 = Offset(heightX, widthY);
      Offset p3 = Offset(heightX + (0.25 * pixelSize), widthY);

      _drawCurve(p1, p2, p3, canvas);
    }

    //bottom left check
    if (matrix[y + 1][x] && matrix[y][x - 1] && matrix[y + 1][x - 1]) {
      Offset p1 = Offset(heightX, widthY + pixelSize - (0.25 * pixelSize));
      Offset p2 = Offset(heightX, widthY + pixelSize);
      Offset p3 = Offset(heightX + (0.25 * pixelSize), widthY + pixelSize);

      _drawCurve(p1, p2, p3, canvas);
    }

    //top right check
    if (matrix[y - 1][x] && matrix[y][x + 1] && matrix[y - 1][x + 1]) {
      Offset p1 = Offset(heightX + pixelSize - (0.25 * pixelSize), widthY);
      Offset p2 = Offset(heightX + pixelSize, widthY);
      Offset p3 = Offset(heightX + pixelSize, widthY + (0.25 * pixelSize));

      _drawCurve(p1, p2, p3, canvas);
    }
  }

  //Round the corners and paint it
  void _setShape(int x, int y, Rect squareRect, Paint paint, List matrix,
      Canvas canvas, int n) {
    bool bottomRight = false;
    bool bottomLeft = false;
    bool topRight = false;
    bool topLeft = false;

    //if it is dot (arount an empty place)
    if (!matrix[y + 1][x] &&
        !matrix[y][x + 1] &&
        !matrix[y - 1][x] &&
        !matrix[y][x - 1]) {
      canvas.drawRRect(
          RRect.fromRectAndCorners(squareRect,
              bottomRight: Radius.circular(2.5),
              bottomLeft: Radius.circular(2.5),
              topLeft: Radius.circular(2.5),
              topRight: Radius.circular(2.5)),
          paint);
      return;
    }

    //bottom right check
    if (!matrix[y + 1][x] && !matrix[y][x + 1]) {
      bottomRight = true;
    }

    //top left check
    if (!matrix[y - 1][x] && !matrix[y][x - 1]) {
      topLeft = true;
    }

    //bottom left check
    if (!matrix[y + 1][x] && !matrix[y][x - 1]) {
      bottomLeft = true;
    }

    //top right check
    if (!matrix[y - 1][x] && !matrix[y][x + 1]) {
      topRight = true;
    }

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          squareRect,
          bottomRight: bottomRight ? Radius.circular(6.0) : Radius.zero,
          bottomLeft: bottomLeft ? Radius.circular(6.0) : Radius.zero,
          topLeft: topLeft ? Radius.circular(6.0) : Radius.zero,
          topRight: topRight ? Radius.circular(6.0) : Radius.zero,
        ),
        paint);

    //if it is dot (arount an empty place)
    if (!bottomLeft && !bottomRight && !topLeft && !topRight) {
      canvas.drawRect(squareRect, paint);
    }
  }

  void _paintDefault(Canvas canvas, Size size) {
    var _paint = Paint()
      ..style = PaintingStyle.fill
      ..color = this.elementColor
      ..isAntiAlias = true;

    ///size of point
    double pixelSize = size.width / _qrCode.moduleCount;

    for (int x = 0; x < _qrCode.moduleCount; x++) {
      for (int y = 0; y < _qrCode.moduleCount; y++) {
        if (image != null &&
            x >= deletePixelCount &&
            y >= deletePixelCount &&
            x < _qrCode.moduleCount - deletePixelCount &&
            y < _qrCode.moduleCount - deletePixelCount) continue;

        if (_qrCode.isDark(y, x)) {
          canvas.drawRect(
              Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
              _paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
