import 'dart:ui';

import 'package:meta/meta.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_brush.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_shape.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_module_extensions.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_rectangle_extensions.dart';

/// A dots QR Code style.
@sealed
class PrettyQrDotsSymbol implements PrettyQrShape {
  /// The color or brush to use when filling the QR Code.
  @nonVirtual
  final Color color;

  /// Defines the ratio (0.0-1.0) how compact the dots will be.
  @nonVirtual
  final double density;

  /// Turns on the unified view to display `Finder Pattern`.
  @nonVirtual
  final bool unifiedFinderPattern;

  /// Turns on the unified view to display `Alignment Patterns`.
  @nonVirtual
  final bool unifiedAlignmentPatterns;

  /// The default value for [density].
  static const kDefaultDensity = 1.0;

  /// Creates a dots QR shape.
  @literal
  const PrettyQrDotsSymbol({
    this.color = const Color(0xFF000000),
    this.density = kDefaultDensity,
    this.unifiedFinderPattern = true,
    this.unifiedAlignmentPatterns = true,
  }) : assert(density >= 0.0 && density <= 1.0);

  @override
  void paint(PrettyQrPaintingContext context) {
    final matrix = context.matrix;
    final canvasBounds = context.estimatedBounds;
    final moduleDimension = canvasBounds.longestSide / matrix.version.dimension;

    final dotRadius = moduleDimension / 2;
    final effectiveDotRadius = clampDouble(dotRadius * density, 1.0, dotRadius);

    final brush = PrettyQrBrush.from(color);
    final dotPaint = brush.toPaint(
      canvasBounds,
      textDirection: context.textDirection,
    )..style = PaintingStyle.fill;

    final circlePaint = brush.toPaint(
      canvasBounds,
      textDirection: context.textDirection,
    );
    circlePaint.style = PaintingStyle.stroke;
    circlePaint.strokeWidth = moduleDimension / 1.5;

    for (final module in context.matrix) {
      if (!module.isDark) continue;
      if (unifiedFinderPattern && module.isFinderPattern) continue;
      if (unifiedAlignmentPatterns && module.isAlignmentPattern) continue;

      final rect = module.resolveRect(context);
      context.canvas.drawCircle(rect.center, effectiveDotRadius, dotPaint);
    }

    if (unifiedFinderPattern) {
      for (final pattern in matrix.positionDetectionPatterns) {
        final center = pattern.resolveRect(context).center;
        context.canvas.drawCircle(center, moduleDimension * 1.5, dotPaint);
        context.canvas.drawCircle(center, moduleDimension * 3, circlePaint);
      }
    }

    if (unifiedAlignmentPatterns) {
      for (final pattern in matrix.alignmentPatterns) {
        final center = pattern.resolveRect(context).center;
        context.canvas.drawCircle(center, dotRadius, dotPaint);
        context.canvas.drawCircle(center, moduleDimension * 1.8, circlePaint);
      }
    }
  }

  @override
  PrettyQrDotsSymbol? lerpFrom(PrettyQrShape? a, double t) {
    if (identical(a, this)) {
      return this;
    }

    if (a == null) return this;
    if (a is! PrettyQrDotsSymbol) return null;

    if (t == 0.0) return a;
    if (t == 1.0) return this;

    return PrettyQrDotsSymbol(
      color: PrettyQrBrush.lerp(a.color, color, t)!,
      density: lerpDouble(a.density, density, t)!,
      unifiedFinderPattern:
          t < 0.5 ? a.unifiedFinderPattern : unifiedFinderPattern,
      unifiedAlignmentPatterns:
          t < 0.5 ? a.unifiedAlignmentPatterns : unifiedAlignmentPatterns,
    );
  }

  @override
  PrettyQrDotsSymbol? lerpTo(PrettyQrShape? b, double t) {
    if (identical(this, b)) {
      return this;
    }

    if (b == null) return this;
    if (b is! PrettyQrDotsSymbol) return null;

    if (t == 0.0) return this;
    if (t == 1.0) return b;

    return PrettyQrDotsSymbol(
      color: PrettyQrBrush.lerp(color, b.color, t)!,
      density: lerpDouble(density, b.density, t)!,
      unifiedFinderPattern:
          t < 0.5 ? unifiedFinderPattern : b.unifiedFinderPattern,
      unifiedAlignmentPatterns:
          t < 0.5 ? unifiedAlignmentPatterns : b.unifiedAlignmentPatterns,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      color,
      density,
      unifiedFinderPattern,
      unifiedAlignmentPatterns,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrDotsSymbol &&
        other.color == color &&
        other.density == density &&
        other.unifiedFinderPattern == unifiedFinderPattern &&
        other.unifiedAlignmentPatterns == unifiedAlignmentPatterns;
  }
}
