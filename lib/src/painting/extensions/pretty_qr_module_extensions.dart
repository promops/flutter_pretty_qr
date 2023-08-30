import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_module.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

/// Extensions that apply to QR module.
extension PrettyQrModuleExtension on PrettyQrModule {
  /// Convert this instance into a floating-point rectangle whose coordinates
  /// are relative to a given QR module.
  Rect resolve(PrettyQrPaintingContext context) {
    final size = context.bounds.shortestSide / context.matrix.dimension;
    return Rect.fromLTWH(size * x, size * y, size, size);
  }
}
