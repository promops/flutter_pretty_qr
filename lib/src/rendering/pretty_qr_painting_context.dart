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
}
