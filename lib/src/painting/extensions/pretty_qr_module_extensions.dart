import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_module.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

/// Extensions that apply to QR symbol.
extension PrettyQrModuleExtension on PrettyQrModule {
  /// Convert this instance into a floating-point rectangle whose coordinates
  /// are relative to a given QR module.
  Rect resolveRect(PrettyQrPaintingContext context) {
    final canvasSize = context.estimatedBounds.longestSide;
    final pointSize = canvasSize / context.matrix.dimension;
    return Rect.fromLTWH(pointSize * x, pointSize * y, pointSize, pointSize);
  }
}
