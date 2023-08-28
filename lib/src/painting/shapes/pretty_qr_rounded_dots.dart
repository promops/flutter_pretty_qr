import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:pretty_qr_code/src/model/painting_context.dart';

@sealed
class PrettyQrPrettyDots extends PrettyQrShape {
  static const gap = 0.5;

  /// The corners of dots are rounded by this [BorderRadiusGeometry] value.
  final double roundFactor;

  @literal
  const PrettyQrPrettyDots({this.roundFactor = 0.5})
      : assert(
          roundFactor >= 0 && roundFactor <= 1.0,
          'Round factor must be greater than 0 and less than 1',
        );

  @override
  void paintDark(QrPointPaintingContext context, Rect rect, Point<int> point) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = context.color
      ..isAntiAlias = true;

    //context.canvas.saveLayer(rect, paint);

    drawModuleItem(
      point: point,
      context: context,
      paint: paint,
      squareRect: rect,
    );
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
    required Rect rect,
  }) {
    final padding = (roundFactor / 2).clamp(0.0, 0.5) * rect.longestSide;

    if (context.modules.innerBottomRight(point)) {
      drawCurve(
        rect.bottomRight.translate(-padding, 0),
        rect.bottomRight.translate(gap, gap),
        rect.bottomRight.translate(0, -padding),
        context,
      );
    }

    if (context.modules.innerTopLeft(point)) {
      drawCurve(
        rect.topLeft.translate(0, padding),
        rect.topLeft.translate(-gap, -gap),
        rect.topLeft.translate(padding, 0),
        context,
      );
    }

    if (context.modules.innerBottomLeft(point)) {
      drawCurve(
        rect.bottomLeft.translate(0, -padding),
        rect.bottomLeft.translate(-gap, gap),
        rect.bottomLeft.translate(padding, 0),
        context,
      );
    }

    if (context.modules.innerTopRight(point)) {
      drawCurve(
        rect.topRight.translate(-padding, 0),
        rect.topRight.translate(gap, -gap),
        rect.topRight.translate(0, padding),
        context,
      );
    }
  }

  @override
  void paintWhite(QrPointPaintingContext context, Rect rect, Point<int> point) {
    drawInnerShape(
      point: point,
      context: context,
      rect: rect,
    );
  }

  //Round the corners and paint it
  void drawModuleItem({
    required Point<int> point,
    required Paint paint,
    required QrPointPaintingContext context,
    required Rect squareRect,
  }) {
    final radius = Radius.circular(squareRect.height / 2 * roundFactor.clamp(0.0, 1.0));

    if (context.modules.isDot(point)) {
      return context.canvas.drawRRect(
        RRect.fromRectAndRadius(squareRect, radius / 2),
        paint,
      );
    }

    final bottomRight = context.modules.roundBottomRight(point);
    final bottomLeft = context.modules.roundBottomLeft(point);
    final topLeft = context.modules.roundTopLeft(point);
    final topRight = context.modules.roundTopRight(point);

    final neighbours = context.modules.getNeighbours(point);

    final withGap = Rect.fromLTRB(
      neighbours.contains(Alignment.centerLeft) ? squareRect.left - gap : squareRect.left,
      neighbours.contains(Alignment.topCenter) ? squareRect.top - gap : squareRect.top,
      neighbours.contains(Alignment.centerRight) ? squareRect.right + gap : squareRect.right,
      neighbours.contains(Alignment.bottomCenter) ? squareRect.bottom + gap : squareRect.bottom,
    );

    final withCorners = RRect.fromRectAndCorners(
      withGap,
      bottomRight: bottomRight ? radius : Radius.zero,
      bottomLeft: bottomLeft ? radius : Radius.zero,
      topLeft: topLeft ? radius : Radius.zero,
      topRight: topRight ? radius : Radius.zero,
    );

    context.canvas.drawRRect(
      withCorners,
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
