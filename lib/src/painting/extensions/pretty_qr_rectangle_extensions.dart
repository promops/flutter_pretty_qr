import 'dart:math';

import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

/// Extensions that apply to [Point<int>].
extension PrettyQrRectanglePaintExtension on Rectangle<int> {
  /// Convert this instance into a floating-point rectangle whose coordinates
  /// are relative to a given QR Symbol.
  @pragma('vm:prefer-inline')
  Rect resolveRect(PrettyQrPaintingContext context) {
    final canvasDimension = context.estimatedBounds.longestSide;
    final moduleDimension = canvasDimension / context.matrix.version.dimension;
    return Rect.fromLTRB(
      left * moduleDimension,
      top * moduleDimension,
      (left + width + 1) * moduleDimension,
      (top + height + 1) * moduleDimension,
    );
  }
}
