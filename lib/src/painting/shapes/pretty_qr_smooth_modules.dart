import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_shape.dart';
import 'package:pretty_qr_code/src/base/pretty_qr_neighbour_direction.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_module_extensions.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_neighbour_direction_extensions.dart';

/// A rectangular modules with smoothed flow.
@sealed
class PrettyQrSmoothModules extends PrettyQrShape {
  /// The color of QR dots.
  @nonVirtual
  final Color color;

  /// The corners of dots are rounded by this [BorderRadiusGeometry] value.
  @nonVirtual
  final double roundFactor;

  /// Creates a pretty QR shape.
  @literal
  const PrettyQrSmoothModules({
    this.roundFactor = 1,
    this.color = const Color(0xFF000000),
  })  : assert(roundFactor <= 1, 'roundFactor must be less than 1'),
        assert(roundFactor >= 0, 'roundFactor must be greater than 0');

  @override
  void paint(PrettyQrPaintingContext context) {
    final path = Path();
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    for (final module in context.matrix) {
      final moduleRect = module.resolve(context);
      final moduleNeighbours = context.matrix.getNeighboursDirections(module);

      if (module.isDark) {
        path.addRRect(
          transformDarkModuleRect(moduleRect, moduleNeighbours),
        );
      } else {
        path.addPath(
          transformWhiteModuleRect(moduleRect, moduleNeighbours),
          Offset.zero,
        );
      }
    }

    context.canvas.drawPath(path, paint);
  }

  @protected
  RRect transformDarkModuleRect(
    final Rect moduleRect,
    final Set<PrettyQrNeighbourDirection> neighbours,
  ) {
    final cornersRadius = Radius.circular(
      moduleRect.shortestSide / 2 * roundFactor.clamp(0.0, 1.0),
    );

    if (!neighbours.hasClosest) {
      return RRect.fromRectAndRadius(moduleRect, cornersRadius / 2);
    }

    return RRect.fromRectAndCorners(
      moduleRect,
      topLeft: neighbours.atTopOrLeft ? Radius.zero : cornersRadius,
      topRight: neighbours.atTopOrRight ? Radius.zero : cornersRadius,
      bottomLeft: neighbours.atBottomOrLeft ? Radius.zero : cornersRadius,
      bottomRight: neighbours.atBottomOrRight ? Radius.zero : cornersRadius,
    );
  }

  @protected
  Path transformWhiteModuleRect(
    final Rect moduleRect,
    final Set<PrettyQrNeighbourDirection> neighbours,
  ) {
    final padding = (roundFactor / 2).clamp(0.0, 0.5) * moduleRect.longestSide;

    if (neighbours.atTopAndLeft && neighbours.atToptLeft) {
      return buildInnerCornerShape(
        moduleRect.topLeft.translate(0, padding),
        moduleRect.topLeft,
        moduleRect.topLeft.translate(padding, 0),
      );
    }

    if (neighbours.atTopAndRight && neighbours.atToptRight) {
      return buildInnerCornerShape(
        moduleRect.topRight.translate(-padding, 0),
        moduleRect.topRight,
        moduleRect.topRight.translate(0, padding),
      );
    }

    if (neighbours.atBottomAndLeft && neighbours.atBottomLeft) {
      return buildInnerCornerShape(
        moduleRect.bottomLeft.translate(0, -padding),
        moduleRect.bottomLeft,
        moduleRect.bottomLeft.translate(padding, 0),
      );
    }

    if (neighbours.atBottomAndRight && neighbours.atBottomRight) {
      return buildInnerCornerShape(
        moduleRect.bottomRight.translate(-padding, 0),
        moduleRect.bottomRight,
        moduleRect.bottomRight.translate(0, -padding),
      );
    }

    return Path();
  }

  @protected
  Path buildInnerCornerShape(Offset p1, Offset p2, Offset p3) {
    return Path()
      ..moveTo(p1.dx, p1.dy)
      ..quadraticBezierTo(p2.dx, p2.dy, p3.dx, p3.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p1.dx, p1.dy)
      ..close();
  }

  @override
  PrettyQrSmoothModules? lerpFrom(PrettyQrShape? a, double t) {
    if (identical(a, this)) {
      return this;
    }

    if (a == null) return this;
    if (a is! PrettyQrSmoothModules) return null;

    if (t == 0.0) return a;
    if (t == 1.0) return this;

    return PrettyQrSmoothModules(
      color: Color.lerp(a.color, color, t)!,
      roundFactor: lerpDouble(a.roundFactor, roundFactor, t)!,
    );
  }

  @override
  PrettyQrSmoothModules? lerpTo(PrettyQrShape? b, double t) {
    if (identical(this, b)) {
      return this;
    }

    if (b == null) return this;
    if (b is! PrettyQrSmoothModules) return null;

    if (t == 0.0) return this;
    if (t == 1.0) return b;

    return PrettyQrSmoothModules(
      color: Color.lerp(color, b.color, t)!,
      roundFactor: lerpDouble(roundFactor, b.roundFactor, t)!,
    );
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
