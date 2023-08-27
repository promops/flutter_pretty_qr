import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:pretty_qr_code/src/interface/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/model/painting_context.dart';
import 'dart:ui' as ui;

class PrettyQrCodePainter extends CustomPainter {
  final PrettyQrDecoration decoration;
  final QrImage qrImage;
  final ui.Image? image;

  const PrettyQrCodePainter({
    required this.decoration,
    required this.qrImage,
    this.image,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final context = QrPointPaintingContext(
      canvas: canvas,
      image: qrImage,
      color: decoration.color,
      dimension: size.shortestSide / qrImage.moduleCount,
    );

    if (image != null) {
      final imageSize = Size(image!.width.toDouble(), image!.height.toDouble());

      final src = Alignment.center.inscribe(
        imageSize,
        Rect.fromLTWH(0, 0, image!.width.toDouble(), image!.height.toDouble()),
      );

      final scale = decoration.image!.scale;
      final rect = Rect.fromLTWH(
        (size.width - size.width * scale) / 2,
        (size.height - size.height * scale) / 2,
        size.width * scale,
        size.height * scale,
      );

      final dst = Alignment.center.inscribe(
        Size(size.height * scale, size.height * scale),
        rect,
      );

      // canvas.drawRect(rect, Paint()..color = Colors.red);
      canvas.drawImageRect(image!, src, dst, Paint());

      for (int x = 0; x < qrImage.moduleCount; ++x) {
        for (int y = 0; y < qrImage.moduleCount; ++y) {
          final dotRect = Rect.fromLTWH(
            x * context.dimension,
            y * context.dimension,
            context.dimension,
            context.dimension,
          );

          if (rect.overlaps(dotRect)) continue;
          decoration.shape.paintPoint(context, Point(x, y));
        }
      }
    }
  }

  @override
  bool shouldRepaint(PrettyQrCodePainter oldDelegate) {
    return oldDelegate.decoration != decoration ||
        oldDelegate.qrImage != qrImage ||
        oldDelegate.image != image;
  }
}

// class PrettyQrMatrix {
//   @nonVirtual
//   final List<List<bool>> data;

//   PrettyQrMatrix(this.data);

//   //   PrettyQrMatrix overlaps(Rect other) {
//   //   if (right <= other.left || other.right <= left)
//   //     return false;
//   //   if (bottom <= other.top || other.bottom <= top)
//   //     return false;
//   //   return true;
//   // }

// }
