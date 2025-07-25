import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';

/// {@template pretty_qr_code.rendering.PrettyQrPaintingContext}
/// A place to paint QR.
/// {@endtemplate}
@sealed
class PrettyQrPaintingContext {
  /// The canvas on which to paint.
  @nonVirtual
  final Canvas canvas;

  /// The bounds within which the painting context's [canvas] will record
  /// painting commands.
  final Rect estimatedBounds;

  /// {@macro pretty_qr_code.base.PrettyQrMatrix}
  @nonVirtual
  final PrettyQrMatrix matrix;

  /// The reading direction of the language.
  @nonVirtual
  final TextDirection? textDirection;

  /// Creates a QR painting context.
  @literal
  const PrettyQrPaintingContext(
    this.canvas,
    this.estimatedBounds, {
    required this.matrix,
    this.textDirection,
  });

  /// Returns QR code bounds dimension.
  @pragma('vm:prefer-inline')
  double get boundsDimension {
    assert(
      estimatedBounds.width == estimatedBounds.height,
      'The estimated bounds should be a square.',
    );
    return estimatedBounds.width;
  }

  /// Creates a copy of this [PrettyQrPaintingContext] but with the given fields
  /// replaced with the new values.
  @factory
  @useResult
  PrettyQrPaintingContext copyWith({
    final PrettyQrMatrix? matrix,
    final TextDirection? textDirection,
  }) {
    return PrettyQrPaintingContext(
      canvas,
      estimatedBounds,
      matrix: matrix ?? this.matrix,
      textDirection: textDirection ?? this.textDirection,
    );
  }
}
