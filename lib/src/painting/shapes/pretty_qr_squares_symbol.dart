// ignore_for_file: avoid-similar-names

import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_render_capabilities.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_brush.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_shape.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_module_extensions.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_rectangle_extensions.dart';

/// A square modules that can be rounded.
@sealed
class PrettyQrSquaresSymbol implements PrettyQrShape {
  /// The color or brush to use when filling the QR Code.
  @nonVirtual
  final Color color;

  /// Defines the ratio (`0.0`-`1.0`) how compact the modules will be.
  @nonVirtual
  final double density;

  /// The amount of rounding to be applied to the modules.
  ///
  /// This is a value between zero and one which describes how rounded the
  /// module should be. A value of zero means no rounding (sharp corners),
  /// and a value of one means that the entire module is a portion of a circle.
  final double rounding;

  /// Turns on the unified view to display `Finder Pattern`.
  @nonVirtual
  final bool unifiedFinderPattern;

  /// Creates a QR Code shape in which the modules have rounded corners.
  @literal
  const PrettyQrSquaresSymbol({
    this.color = const Color(0xFF000000),
    this.density = 1,
    this.rounding = 0,
    this.unifiedFinderPattern = false,
  })  : assert(density >= 0.0 && density <= 1.0),
        assert(rounding >= 0.0 && rounding <= 1.0);

  @override
  void paint(PrettyQrPaintingContext context) {
    final path = Path();
    final brush = PrettyQrBrush.from(color);

    final matrix = context.matrix;
    final canvasBounds = context.estimatedBounds;
    final moduleDimension = canvasBounds.longestSide / matrix.version.dimension;

    final fillPaint = brush.toPaint(
      canvasBounds,
      textDirection: context.textDirection,
    )..style = PaintingStyle.fill;

    if (unifiedFinderPattern) {
      final strokePaint = brush.toPaint(
        canvasBounds,
        textDirection: context.textDirection,
      );
      strokePaint.style = PaintingStyle.stroke;
      strokePaint.strokeWidth = moduleDimension / 1.5;

      final detectionPatternDot = ContinuousRectangleBorder(
        side: BorderSide(width: moduleDimension / 3),
        borderRadius: BorderRadius.all(
          Radius.circular(moduleDimension * clampDouble(rounding * 6, 0, 3)),
        ),
      );

      final detectionPatternBorder = ContinuousRectangleBorder(
        side: BorderSide(width: moduleDimension / 3),
        borderRadius: BorderRadius.all(
          Radius.circular(moduleDimension * clampDouble(rounding * 8, 0, 4)),
        ),
      );

      final effectiveDotRadius = clampDouble(rounding * 1.4, 0, 1.4);
      final effectivePatterRadius = clampDouble(rounding * 3.5, 0, 3.5);

      for (final pattern in matrix.positionDetectionPatterns) {
        final patternRect = pattern.resolveRect(context);
        if (rounding > 0 && rounding <= 0.5) {
          final patterPath = detectionPatternBorder.getInnerPath(
            patternRect,
            textDirection: context.textDirection,
          );
          context.canvas.drawPath(patterPath, strokePaint);

          final patterDotPath = detectionPatternDot.getInnerPath(
            patternRect.deflate(moduleDimension * 1.4),
            textDirection: context.textDirection,
          );
          context.canvas.drawPath(patterDotPath, fillPaint);
        } else {
          final patternRRect = RRect.fromRectAndRadius(
            patternRect,
            Radius.circular(moduleDimension * effectivePatterRadius),
          ).deflate(moduleDimension / 3);
          context.canvas.drawRRect(patternRRect, strokePaint);

          final patternDotRRect = RRect.fromRectAndRadius(
            patternRect,
            Radius.circular(moduleDimension * (effectiveDotRadius + 2)),
          ).deflate(moduleDimension * 1.8);
          context.canvas.drawRRect(patternDotRRect, fillPaint);
        }
      }
    }

    final radius = moduleDimension / 2;
    final effectiveRadius = clampDouble(radius * rounding, 0, radius);
    final effectiveDensity = radius - clampDouble(radius * density, 1, radius);

    for (final module in context.matrix) {
      if (!module.isDark) continue;
      if (unifiedFinderPattern && module.isFinderPattern) continue;

      final moduleRect = module.resolveRect(context);
      final moduleRRect = RRect.fromRectAndRadius(
        moduleRect,
        Radius.circular(effectiveRadius),
      ).deflate(effectiveDensity);

      if (PrettyQrRenderCapabilities.needsAvoidComplexPaths) {
        context.canvas.drawRRect(moduleRRect, fillPaint);
      } else {
        path.addRRect(moduleRRect);
      }
    }

    context.canvas.drawPath(path, fillPaint);
  }

  @override
  PrettyQrSquaresSymbol? lerpFrom(PrettyQrShape? a, double t) {
    if (identical(a, this)) {
      return this;
    }

    if (a == null) return this;
    if (a is! PrettyQrSquaresSymbol) return null;

    if (t == 0.0) return a;
    if (t == 1.0) return this;

    return PrettyQrSquaresSymbol(
      color: PrettyQrBrush.lerp(a.color, color, t)!,
      density: lerpDouble(a.density, density, t)!,
      rounding: lerpDouble(a.rounding, rounding, t)!,
      unifiedFinderPattern:
          t < 0.5 ? a.unifiedFinderPattern : unifiedFinderPattern,
    );
  }

  @override
  PrettyQrSquaresSymbol? lerpTo(PrettyQrShape? b, double t) {
    if (identical(this, b)) {
      return this;
    }

    if (b == null) return this;
    if (b is! PrettyQrSquaresSymbol) return null;

    if (t == 0.0) return this;
    if (t == 1.0) return b;

    return PrettyQrSquaresSymbol(
      color: PrettyQrBrush.lerp(color, b.color, t)!,
      density: lerpDouble(density, b.density, t)!,
      rounding: lerpDouble(rounding, b.rounding, t)!,
      unifiedFinderPattern:
          t < 0.5 ? unifiedFinderPattern : b.unifiedFinderPattern,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      color,
      density,
      rounding,
      unifiedFinderPattern,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrSquaresSymbol &&
        other.color == color &&
        other.density == density &&
        other.rounding == rounding &&
        other.unifiedFinderPattern == unifiedFinderPattern;
  }
}
