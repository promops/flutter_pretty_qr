import 'dart:math';

import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/model/painting_context.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_shape.dart';

/// TODO: `PrettyQrDefaultDots` description
@sealed
class PrettyQrDefaultDots extends PrettyQrShape {
  @literal
  const PrettyQrDefaultDots();

  @override
  void paintDark(QrPointPaintingContext context, Rect rect, Point<int> point) {
    final paint = Paint()
      ..color = context.color
      ..style = PaintingStyle.fill;

    context.canvas.drawRect(rect, paint);
  }

  @override
  void paintWhite(QrPointPaintingContext context, Rect rect, Point<int> point) {}
}
