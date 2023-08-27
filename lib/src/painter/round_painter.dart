import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:pretty_qr_code/src/model/painting_context.dart';
import 'package:pretty_qr_code/src/painter/utils.dart';

@sealed
class PrettyQrPrettyDots extends PrettyQrShapeDots {
  /// The corners of dots are rounded by this [BorderRadiusGeometry] value.
  final double roundFactor;

  @literal
  const PrettyQrPrettyDots({this.roundFactor = 0.5})
      : assert(
          roundFactor >= 0 && roundFactor <= 1.0,
          'Round factor must be greater than 0 and less than 1',
        );

  @override
  void paintPoint(QrPointPaintingContext context, Point<int> point) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = context.color
      ..isAntiAlias = true;

    if (context.image.hasPoint(point)) {
      drawModuleItem(
        point: point,
        context: context,
        paint: paint,
      );
    } else {
      drawInnerShape(
        point: point,
        context: context,
      );
    }
  }

  void drawCurve(
    Offset p1,
    Offset p2,
    Offset p3,
    QrPointPaintingContext context,
  ) {
    Path path = Path();

    path.moveTo(p1.dx, p1.dy);
    path.quadraticBezierTo(p2.dx, p2.dy, p3.dx, p3.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p1.dx, p1.dy);
    path.close();

    context.canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.fill
        ..color = context.color,
    );
  }

  void drawInnerShape({
    required Point<int> point,
    required QrPointPaintingContext context,
  }) {
    final padding = (roundFactor / 2).clamp(0.0, 0.5);
    final widthY = context.dimension * point.y;
    final heightX = context.dimension * point.x;

    if (context.image.innerBottomRight(point)) {
      Offset p1 = Offset(
        heightX + context.dimension - (padding * context.dimension),
        widthY + context.dimension,
      );
      Offset p2 = Offset(
        heightX + context.dimension,
        widthY + context.dimension,
      );
      Offset p3 = Offset(
        heightX + context.dimension,
        widthY + context.dimension - (padding * context.dimension),
      );

      drawCurve(p1, p2, p3, context);
    }

    if (context.image.innerTopLeft(point)) {
      Offset p1 = Offset(heightX, widthY + (padding * context.dimension));
      Offset p2 = Offset(heightX, widthY);
      Offset p3 = Offset(heightX + (padding * context.dimension), widthY);

      drawCurve(p1, p2, p3, context);
    }

    if (context.image.innerBottomLeft(point)) {
      Offset p1 = Offset(heightX, widthY + context.dimension - (padding * context.dimension));
      Offset p2 = Offset(heightX, widthY + context.dimension);
      Offset p3 = Offset(heightX + (padding * context.dimension), widthY + context.dimension);

      drawCurve(p1, p2, p3, context);
    }

    if (context.image.innerTopRight(point)) {
      Offset p1 = Offset(heightX + context.dimension - (padding * context.dimension), widthY);
      Offset p2 = Offset(heightX + context.dimension, widthY);
      Offset p3 = Offset(heightX + context.dimension, widthY + (padding * context.dimension));

      drawCurve(p1, p2, p3, context);
    }
  }

  //Round the corners and paint it
  void drawModuleItem({
    required Point<int> point,
    required Paint paint,
    required QrPointPaintingContext context,
  }) {
    final squareRect = Rect.fromLTWH(
      point.x * context.dimension,
      point.y * context.dimension,
      context.dimension,
      context.dimension,
    );
    final radius = Radius.circular(context.dimension / 2 * roundFactor.clamp(0.0, 1.0));
    print(radius);

    if (context.image.isDot(point)) {
      return context.canvas.drawRRect(
        RRect.fromRectAndRadius(squareRect, radius / 2),
        paint,
      );
    }

    context.canvas.drawRRect(
      RRect.fromRectAndCorners(
        squareRect,
        bottomRight: context.image.roundBottomRight(point) ? radius : Radius.zero,
        bottomLeft: context.image.roundBottomLeft(point) ? radius : Radius.zero,
        topLeft: context.image.roundTopLeft(point) ? radius : Radius.zero,
        topRight: context.image.roundTopRight(point) ? radius : Radius.zero,
      ),
      paint,
    );
  }

  @override
  int get hashCode {
    return runtimeType.hashCode ^ roundFactor.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrPrettyDots && roundFactor == other.roundFactor;
  }
}
