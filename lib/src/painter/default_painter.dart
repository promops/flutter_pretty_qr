import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:pretty_qr_code/src/model/painting_context.dart';
import 'package:pretty_qr_code/src/painter/utils.dart';
import 'package:meta/meta.dart';

/// DOCS.
@sealed
class PrettyQrDefaultDots extends PrettyQrShapeDots {
  @literal
  const PrettyQrDefaultDots();

  @override
  void paintPoint(QrPointPaintingContext context, Point<int> point) {
    if (!context.image.hasPoint(point)) return;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = context.color
      ..isAntiAlias = true;

    context.canvas.drawRect(
      Rect.fromLTWH(
        point.x * context.dimension,
        point.y * context.dimension,
        context.dimension,
        context.dimension,
      ),
      paint,
    );
  }
}
