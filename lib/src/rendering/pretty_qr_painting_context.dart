import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';

/// {@template pretty_qr_code.PrettyQrPaintingContext}
/// A place to paint QR.
/// {@endtemplate}
@sealed
class PrettyQrPaintingContext {
  /// The bounds within which the painting context's [canvas] will record
  /// painting commands.
  final Rect bounds;

  /// The canvas on which to paint.
  @nonVirtual
  final Canvas canvas;

  /// {@macro pretty_qr_code.PrettyQrMatrix}
  @nonVirtual
  final PrettyQrMatrix matrix;

  /// The reading direction of the language.
  @nonVirtual
  final TextDirection? textDirection;

  /// Creates a QR painting context.
  @literal
  const PrettyQrPaintingContext({
    required this.bounds,
    required this.canvas,
    required this.matrix,
    this.textDirection,
  });
}
