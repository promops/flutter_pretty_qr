import 'package:flutter/animation.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';

/// An interpolation between two [PrettyQrDecoration]s.
///
/// This class specializes the interpolation of [Tween<PrettyQrDecoration>] to
/// use [PrettyQrDecoration.lerp].
class PrettyQrDecorationTween extends Tween<PrettyQrDecoration> {
  /// Creates a QR decoration tween.
  PrettyQrDecorationTween({super.begin, super.end});

  /// Returns the value this variable has at the given animation clock value.
  @override
  PrettyQrDecoration lerp(double t) {
    return PrettyQrDecoration.lerp(begin, end, t)!;
  }
}
