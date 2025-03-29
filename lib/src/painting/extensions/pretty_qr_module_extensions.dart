import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_module.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

/// Extension that apply to QR module.
extension PrettyQrModuleExtension on PrettyQrModule {
  /// Convert this instance into a floating-point rectangle whose coordinates
  /// are relative to a given QR Symbol.
  @pragma('vm:prefer-inline')
  Rect resolveRect(PrettyQrPaintingContext context) {
    final pointSize = context.boundsDimension / context.matrix.dimension;
    return Rect.fromLTWH(pointSize * x, pointSize * y, pointSize, pointSize);
  }
}
