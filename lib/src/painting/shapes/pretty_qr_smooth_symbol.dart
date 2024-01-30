import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration_gradient.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_shape.dart';
import 'package:pretty_qr_code/src/base/pretty_qr_neighbour_direction.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_render_experiments.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_module_extensions.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_neighbour_direction_extensions.dart';

/// A rectangular modules with smoothed flow.
@sealed
class PrettyQrSmoothSymbol extends PrettyQrShape {
  /// The color to use when filling the QR code.
  @nonVirtual
  final Color color;

  /// Optional gradient to fill the QR code.
  final PrettyQrGradient? prettyQrGradient;

  /// The corners of dots are rounded by this value.
  @nonVirtual
  final double roundFactor;

  /// Creates a pretty QR shape.
  ///
  /// [roundFactor] defines how much the corners will be rounded.
  /// [color] is used as a fallback if no gradient is provided.
  /// [gradient] is an optional gradient to fill the QR code.
  @literal
  const PrettyQrSmoothSymbol({
    this.roundFactor = 1,
    this.color = const Color(0xFF000000),
    this.prettyQrGradient,
  })  : assert(roundFactor <= 1, 'roundFactor must be less than or equal to 1'),
        assert(
            roundFactor >= 0, 'roundFactor must be greater than or equal to 0');

  @override
  void paint(PrettyQrPaintingContext context) {
    final path = Path();
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    // Use gradient if provided, otherwise use solid color
    if (prettyQrGradient != null) {
      paint.shader = prettyQrGradient!.linearGradient
          .createShader(context.estimatedBounds);
    } else {
      paint.color = color;
    }

    for (final module in context.matrix) {
      final moduleRect = module.resolveRect(context);
      final moduleNeighbours = context.matrix.getNeighboursDirections(module);

      Path modulePath;
      if (module.isDark) {
        modulePath = Path()
          ..addRRect(_transformDarkModuleRect(moduleRect, moduleNeighbours))
          ..close();
      } else {
        modulePath = _transformWhiteModuleRect(moduleRect, moduleNeighbours);
      }

      if (PrettyQrRenderExperiments.needsAvoidComplexPaths) {
        context.canvas.drawPath(modulePath, paint);
      } else {
        path.addPath(modulePath, Offset.zero);
      }
    }

    path.close();
    context.canvas.drawPath(path, paint);
  }

  @protected
  RRect _transformDarkModuleRect(
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
  Path _transformWhiteModuleRect(
    final Rect moduleRect,
    final Set<PrettyQrNeighbourDirection> neighbours,
  ) {
    final path = Path();
    final padding = (roundFactor / 2).clamp(0.0, 0.5) * moduleRect.longestSide;

    if (neighbours.atTopAndLeft && neighbours.atToptLeft) {
      path.addPath(
        _buildInnerCornerShape(
          moduleRect.topLeft.translate(0, padding),
          moduleRect.topLeft,
          moduleRect.topLeft.translate(padding, 0),
        ),
        Offset.zero,
      );
    }

    if (neighbours.atTopAndRight && neighbours.atToptRight) {
      path.addPath(
        _buildInnerCornerShape(
          moduleRect.topRight.translate(-padding, 0),
          moduleRect.topRight,
          moduleRect.topRight.translate(0, padding),
        ),
        Offset.zero,
      );
    }

    if (neighbours.atBottomAndLeft && neighbours.atBottomLeft) {
      path.addPath(
        _buildInnerCornerShape(
          moduleRect.bottomLeft.translate(0, -padding),
          moduleRect.bottomLeft,
          moduleRect.bottomLeft.translate(padding, 0),
        ),
        Offset.zero,
      );
    }

    if (neighbours.atBottomAndRight && neighbours.atBottomRight) {
      path.addPath(
        _buildInnerCornerShape(
          moduleRect.bottomRight.translate(-padding, 0),
          moduleRect.bottomRight,
          moduleRect.bottomRight.translate(0, -padding),
        ),
        Offset.zero,
      );
    }

    return path..close();
  }

  @protected
  Path _buildInnerCornerShape(Offset p1, Offset p2, Offset p3) {
    return Path()
      ..moveTo(p1.dx, p1.dy)
      ..quadraticBezierTo(p2.dx, p2.dy, p3.dx, p3.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p1.dx, p1.dy)
      ..close();
  }

  @override
  PrettyQrSmoothSymbol? lerpFrom(PrettyQrShape? a, double t) {
    if (identical(a, this)) {
      return this;
    }

    if (a == null) return this;
    if (a is! PrettyQrSmoothSymbol) return null;

    if (t == 0.0) return a;
    if (t == 1.0) return this;

    return PrettyQrSmoothSymbol(
      color: Color.lerp(a.color, color, t)!,
      roundFactor: lerpDouble(a.roundFactor, roundFactor, t)!,
    );
  }

  @override
  PrettyQrSmoothSymbol? lerpTo(PrettyQrShape? b, double t) {
    if (identical(this, b)) {
      return this;
    }

    if (b == null) return this;
    if (b is! PrettyQrSmoothSymbol) return null;

    if (t == 0.0) return this;
    if (t == 1.0) return b;

    return PrettyQrSmoothSymbol(
      color: Color.lerp(color, b.color, t)!,
      roundFactor: lerpDouble(roundFactor, b.roundFactor, t)!,
    );
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, color, roundFactor);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrSmoothSymbol &&
        other.color == color &&
        other.roundFactor == roundFactor;
  }
}
