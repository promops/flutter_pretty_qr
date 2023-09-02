import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';

/// {@template pretty_qr_code.PrettyQrPaintingContext}
/// A place to paint QR.
/// {@endtemplate}
@sealed
class PrettyQrPaintingContext extends PaintingContext {
  /// {@macro pretty_qr_code.PrettyQrMatrix}
  @nonVirtual
  final PrettyQrMatrix matrix;

  /// The reading direction of the language.
  @nonVirtual
  final TextDirection? textDirection;

  /// Creates a QR painting context.
  PrettyQrPaintingContext(
    super._containerLayer,
    super.estimatedBounds, {
    required this.matrix,
    this.textDirection,
  });
}
