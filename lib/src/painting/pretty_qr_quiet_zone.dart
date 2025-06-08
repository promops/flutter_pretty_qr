// ignore_for_file: avoid-referencing-subclasses, internal API.

import 'dart:ui';

import 'package:meta/meta.dart';

/// {@template pretty_qr_code.painting.PrettyQrQuietZone}
/// An immutable region which shall be free of all other markings, surrounding
/// the symbol on all four sides.
/// {@endtemplate}
///
/// {@template pretty_qr_code.painting.PrettyQrQuietZone.standard}
/// According to the standard, quiet zone width shall be 4 or more modules and
/// its nominal reflectance value shall be equal to that of the light modules.
/// {@endtemplate}
@sealed
@immutable
abstract class PrettyQrQuietZone {
  /// The QR code `Quiet Zone` width.
  num get value;

  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  @literal
  const PrettyQrQuietZone();

  /// Creates `Quiet Zone` that calculates its width using logical pixels.
  ///
  /// {@macro pretty_qr_code.painting.PrettyQrQuietZone.standard}
  ///
  /// This is not recommended for use in general. This option was introduced to
  /// workaround for non-standard layout needs. In other cases, it is strongly
  /// recommended to use [PrettyQrQuietZone.modules] constructor with a value
  /// greater than or equal to 4.
  @literal
  const factory PrettyQrQuietZone.pixels(
    double value,
  ) = PrettyQrPixelsQuietZone;

  /// Creates `Quiet Zone` that calculates its width using modules size.
  ///
  /// {@macro pretty_qr_code.painting.PrettyQrQuietZone.standard}
  @literal
  const factory PrettyQrQuietZone.modules(
    int value,
  ) = PrettyQrModulesQuietZone;

  /// A [PrettyQrQuietZone] with zero width.
  static const zero = PrettyQrQuietZone.modules(0);

  /// A [PrettyQrQuietZone] with width corresponds to 4 module sizes.
  ///
  /// {@macro pretty_qr_code.painting.PrettyQrQuietZone.standard}
  static const standard = PrettyQrQuietZone.modules(4);

  /// Linearly interpolates between two [PrettyQrQuietZone]s.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static PrettyQrQuietZone? lerp(
    final PrettyQrQuietZone? a,
    final PrettyQrQuietZone? b,
    final double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (t == 0.0) return a;
    if (t == 1.0) return b;

    if ((a == null || a.value == 0) && b is PrettyQrPixelsQuietZone) {
      return PrettyQrPixelsQuietZone(b.value * t);
    }

    if ((b == null || b.value == 0) && a is PrettyQrPixelsQuietZone) {
      return PrettyQrPixelsQuietZone(a.value * (1.0 - t));
    }

    if (a is PrettyQrPixelsQuietZone && b is PrettyQrPixelsQuietZone) {
      return PrettyQrPixelsQuietZone(lerpDouble(a.value, b.value, t)!);
    }

    return t < 0.5 ? a : b;
  }
}

/// {@template pretty_qr_code.painting.PrettyQrPixelsQuietZone}
/// A `Quiet Zone` that calculates its width using logical pixels.
/// {@endtemplate}
@sealed
@immutable
class PrettyQrPixelsQuietZone extends PrettyQrQuietZone {
  @override
  final double value;

  /// {@macro pretty_qr_code.painting.PrettyQrPixelsQuietZone}
  @literal
  const PrettyQrPixelsQuietZone(this.value);

  @override
  int get hashCode {
    return value.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PrettyQrPixelsQuietZone && other.value == value;
  }
}

/// {@template pretty_qr_code.painting.PrettyQrModulesQuietZone}
/// A `Quiet Zone` that calculates its width using modules size.
/// {@endtemplate}
@sealed
@immutable
class PrettyQrModulesQuietZone extends PrettyQrQuietZone {
  @override
  final int value;

  /// {@macro pretty_qr_code.painting.PrettyQrModulesQuietZone}
  @literal
  const PrettyQrModulesQuietZone(this.value);

  @override
  int get hashCode {
    return value.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PrettyQrModulesQuietZone && other.value == value;
  }
}
