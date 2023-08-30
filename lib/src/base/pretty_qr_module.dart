import 'dart:math';

import 'package:meta/meta.dart';

/// {@template pretty_qr_code.PrettyQrModule}
/// The QR code module.
/// {@endtemplate}
@sealed
class PrettyQrModule extends Point<int> {
  /// Returns `true` if the point is dark.
  @nonVirtual
  final bool isDark;

  /// Creates a QR module.
  @literal
  const PrettyQrModule(
    super.x,
    super.y, {
    required this.isDark,
  });

  @override
  int get hashCode {
    return runtimeType.hashCode ^ super.hashCode ^ isDark.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrModule && super == other && other.isDark == isDark;
  }
}
