import 'dart:math';

import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_shape.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_module_extensions.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_neighbour_direction_extensions.dart';

/// TODO: `PrettyQrSmoothModules` description
@sealed
class PrettyQrSmoothModules extends PrettyQrShape {
  /// The color of QR dots.
  @protected
  final Color color;

  /// The corners of dots are rounded by this [BorderRadiusGeometry] value.
  @protected
  final double roundFactor;

  /// TODO: docs
  @visibleForTesting
  static const gap = 0.5;

  @literal
  const PrettyQrSmoothModules({
    this.roundFactor = 0.5,
    this.color = const Color(0xFF000000),
  })  : assert(roundFactor <= 1, 'roundFactor must be less than 1'),
        assert(roundFactor >= 0, 'roundFactor must be greater than 0');

  @override
  void paint(PrettyQrPaintingContext context) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    for (final module in context.matrix) {
      final moduleRect = module.resolve(context);

      if (!module.isDark) {
        drawInnerShape(point: module, context: context, rect: moduleRect);
      } else {
        drawModuleItem(
          point: module,
          context: context,
          paint: paint,
          squareRect: moduleRect,
        );
      }
    }
  }

  void drawCurve(
    Offset p1,
    Offset p2,
    Offset p3,
    Canvas canvas,
  ) {
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..quadraticBezierTo(p2.dx, p2.dy, p3.dx, p3.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p1.dx, p1.dy)
      ..close();

    canvas.drawPath(
      path,
      // FIXME: дублирование Paint
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  void drawInnerShape({
    required Point<int> point,
    required PrettyQrPaintingContext context,
    required Rect rect,
  }) {
    final padding = (roundFactor / 2).clamp(0.0, 0.5) * rect.longestSide;
    final neighbours = context.matrix.getNeighboursDirections(point);

    if (neighbours.atTopAndLeft && neighbours.atToptLeft) {
      drawCurve(
        rect.topLeft.translate(0, padding),
        rect.topLeft.translate(-gap, -gap),
        rect.topLeft.translate(padding, 0),
        context.canvas,
      );
    }

    if (neighbours.atTopAndRight && neighbours.atToptRight) {
      drawCurve(
        rect.topRight.translate(-padding, 0),
        rect.topRight.translate(gap, -gap),
        rect.topRight.translate(0, padding),
        context.canvas,
      );
    }

    if (neighbours.atBottomAndLeft && neighbours.atBottomLeft) {
      drawCurve(
        rect.bottomLeft.translate(0, -padding),
        rect.bottomLeft.translate(-gap, gap),
        rect.bottomLeft.translate(padding, 0),
        context.canvas,
      );
    }

    if (neighbours.atBottomAndRight && neighbours.atBottomRight) {
      drawCurve(
        rect.bottomRight.translate(-padding, 0),
        rect.bottomRight.translate(gap, gap),
        rect.bottomRight.translate(0, -padding),
        context.canvas,
      );
    }
  }

  // Round the corners and paint it
  void drawModuleItem({
    required Point<int> point,
    required Paint paint,
    required PrettyQrPaintingContext context,
    required Rect squareRect,
  }) {
    final radius = Radius.circular(
      squareRect.height / 2 * roundFactor.clamp(0.0, 1.0),
    );

    final neighbours = context.matrix.getNeighboursDirections(point);
    if (!neighbours.hasClosest) {
      return context.canvas.drawRRect(
        RRect.fromRectAndRadius(squareRect, radius / 2),
        paint,
      );
    }

    final rect = Rect.fromLTRB(
      neighbours.atLeft ? squareRect.left - gap : squareRect.left,
      neighbours.atTop ? squareRect.top - gap : squareRect.top,
      neighbours.atRight ? squareRect.right + gap : squareRect.right,
      neighbours.atBottom ? squareRect.bottom + gap : squareRect.bottom,
    );

    final withCorners = RRect.fromRectAndCorners(
      rect,
      topLeft: neighbours.atTopOrLeft ? Radius.zero : radius,
      topRight: neighbours.atTopOrRight ? Radius.zero : radius,
      bottomLeft: neighbours.atBottomOrLeft ? Radius.zero : radius,
      bottomRight: neighbours.atBottomOrRight ? Radius.zero : radius,
    );

    context.canvas.drawRRect(withCorners, paint);
  }

  @override
  int get hashCode {
    return runtimeType.hashCode ^ Object.hash(color, roundFactor);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrSmoothModules &&
        other.color == color &&
        other.roundFactor == roundFactor;
  }
}
