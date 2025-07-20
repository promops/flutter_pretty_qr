import 'package:meta/meta.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';
import 'package:pretty_qr_code/src/base/components/pretty_qr_component.dart';

import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

/// {@template pretty_qr_code.painting.PrettyQrShape}
/// A base class for shape QR Code symbol.
/// {@endtemplate}
@immutable
abstract class PrettyQrShape {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  @literal
  const PrettyQrShape();

  /// Creates a custom shape.
  ///
  /// The `finderPattern` shape applies to three Position Detection Patterns,
  /// the `timingPatterns` shape applies to horizontal and vertical Timing
  /// Patterns, and the`alignmentPatterns` shape applies to Alignment Patterns.
  ///
  /// All the shapes default to [shape] argument.
  @literal
  @experimental
  const factory PrettyQrShape.custom(
    final PrettyQrShape shape, {
    final PrettyQrShape? finderPattern,
    final PrettyQrShape? timingPatterns,
    final PrettyQrShape? alignmentPatterns,
  }) = PrettyQrCustomShape;

  /// Linearly interpolates from another [PrettyQrShape] (which may be of a
  /// different class) to `this`.
  ///
  /// Instead of calling this directly, use [PrettyQrShape.lerp].
  PrettyQrShape? lerpFrom(PrettyQrShape? a, double t) => null;

  /// Linearly interpolates from `this` to another [PrettyQrShape] (which may be
  /// of a different class).
  ///
  /// Instead of calling this directly, use [PrettyQrShape.lerp].
  PrettyQrShape? lerpTo(PrettyQrShape? b, double t) => null;

  /// Paints the QR matrix on the canvas of the given painting context.
  void paint(PrettyQrPaintingContext context);

  /// Linearly interpolates between two [PrettyQrShape]s.
  ///
  /// This attempts to use [lerpFrom] and [lerpTo] on `b` and `a`
  /// respectively to find a solution.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static PrettyQrShape? lerp(
    final PrettyQrShape? a,
    final PrettyQrShape? b,
    final double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) return b!.lerpFrom(null, t) ?? b;
    if (b == null) return a.lerpTo(null, t) ?? a;

    if (t == 0.0) return a;
    if (t == 1.0) return b;

    return b.lerpFrom(a, t) ?? a.lerpTo(b, t) ?? b;
  }
}

/// A class for creates custom QR Code shape.
@sealed
@experimental
class PrettyQrCustomShape extends PrettyQrShape {
  @nonVirtual
  final PrettyQrShape shape;

  @nonVirtual
  final PrettyQrShape? finderPattern;

  @nonVirtual
  final PrettyQrShape? timingPatterns;

  @nonVirtual
  final PrettyQrShape? alignmentPatterns;

  /// Creates a custom QR Code shape.
  @literal
  const PrettyQrCustomShape(
    this.shape, {
    this.finderPattern,
    this.timingPatterns,
    this.alignmentPatterns,
  });

  @override
  void paint(PrettyQrPaintingContext context) {
    final hasFinderPattern = finderPattern != null;
    final hasTimingPatterns = timingPatterns != null;
    final hasAlignmentPatterns = alignmentPatterns != null;

    if (!hasFinderPattern && !hasTimingPatterns && !hasAlignmentPatterns) {
      shape.paint(context);
      return;
    }

    final matrix = PrettyQrMatrix.masked(
      context.matrix,
      exclude: {
        if (hasFinderPattern) PrettyQrComponentType.finderPattern,
        if (hasTimingPatterns) PrettyQrComponentType.timingPattern,
        if (hasAlignmentPatterns) PrettyQrComponentType.alignmentPattern,
      },
    );
    shape.paint(context.copyWith(matrix: matrix));

    if (hasFinderPattern) {
      finderPattern?.paint(
        context.copyWith(
          matrix: PrettyQrMatrix.masked(
            context.matrix,
            exclude: {
              for (final type in PrettyQrComponentType.values)
                if (type != PrettyQrComponentType.finderPattern) type,
            },
          ),
        ),
      );
    }

    if (hasTimingPatterns) {
      timingPatterns?.paint(
        context.copyWith(
          matrix: PrettyQrMatrix.masked(
            context.matrix,
            exclude: {
              for (final type in PrettyQrComponentType.values)
                if (type != PrettyQrComponentType.timingPattern) type,
            },
          ),
        ),
      );
    }

    if (hasAlignmentPatterns) {
      alignmentPatterns?.paint(
        context.copyWith(
          matrix: PrettyQrMatrix.masked(
            context.matrix,
            exclude: {
              for (final type in PrettyQrComponentType.values)
                if (type != PrettyQrComponentType.alignmentPattern) type,
            },
          ),
        ),
      );
    }
  }

  @override
  PrettyQrCustomShape? lerpFrom(PrettyQrShape? a, double t) {
    if (identical(a, this)) {
      return this;
    }

    if (a == null) return this;
    if (a is! PrettyQrCustomShape) return null;

    if (t == 0.0) return a;
    if (t == 1.0) return this;

    const lerp = PrettyQrShape.lerp;
    return PrettyQrCustomShape(
      lerp(a.shape, shape, t)!,
      finderPattern: lerp(a.finderPattern, finderPattern, t)!,
      timingPatterns: lerp(a.timingPatterns, timingPatterns, t)!,
      alignmentPatterns: lerp(a.alignmentPatterns, alignmentPatterns, t)!,
    );
  }

  @override
  PrettyQrCustomShape? lerpTo(PrettyQrShape? b, double t) {
    if (identical(this, b)) {
      return this;
    }

    if (b == null) return this;
    if (b is! PrettyQrCustomShape) return null;

    if (t == 0.0) return this;
    if (t == 1.0) return b;

    const lerp = PrettyQrShape.lerp;
    return PrettyQrCustomShape(
      lerp(shape, b.shape, t)!,
      finderPattern: lerp(finderPattern, b.finderPattern, t)!,
      timingPatterns: lerp(timingPatterns, b.timingPatterns, t)!,
      alignmentPatterns: lerp(alignmentPatterns, b.alignmentPatterns, t)!,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      shape,
      finderPattern,
      timingPatterns,
      alignmentPatterns,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }

    return other is PrettyQrCustomShape &&
        other.shape == shape &&
        other.finderPattern == finderPattern &&
        other.timingPatterns == timingPatterns &&
        other.alignmentPatterns == alignmentPatterns;
  }
}
