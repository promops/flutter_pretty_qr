// ignore_for_file: avoid-referencing-subclasses, internal API.

import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_brush_extensions.dart';

/// A brush to use when filling the QR Code.
@immutable
abstract class PrettyQrBrush extends Color {
  /// Creates a QR Code brush.
  @literal
  const PrettyQrBrush(super.color);

  /// The completely invisible brush.
  static const transparent = PrettyQrBrush.solid(0x00000000);

  /// Create a brush from [color].
  factory PrettyQrBrush.from(Color color) {
    if (color is PrettyQrBrush) {
      return color;
    }
    return PrettyQrBrush.solid(color.value);
  }

  /// {@macro pretty_qr_code.painting.PrettyQrSolidBrush}
  @literal
  const factory PrettyQrBrush.solid(
    final int value,
  ) = PrettyQrSolidBrush;

  /// {@macro pretty_qr_code.painting.PrettyQrGradientBrush}
  @literal
  const factory PrettyQrBrush.gradient({
    required final Gradient gradient,
  }) = PrettyQrGradientBrush;

  /// Returns a [Paint] for this brush to fill the given [rect].
  Paint toPaint(Rect rect, {TextDirection? textDirection});

  /// Linearly interpolates between two [PrettyQrBrush]s.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static Color? lerp(
    final Color? a,
    final Color? b,
    final double t,
  ) {
    if (identical(a, b)) return a;

    if (t <= 0.0) return a;
    if (t >= 1.0) return b;

    if (b == null || a == null) {
      return t < 0.5 ? a : b;
    }

    if (b is PrettyQrGradientBrush) {
      return PrettyQrBrush.gradient(
        gradient: a is PrettyQrGradientBrush
            ? Gradient.lerp(a.gradient, b.gradient, t)!
            : a.lerpToGradient(b.gradient, t),
      );
    }

    if (a is! PrettyQrGradientBrush) {
      final lerpedColor = Color.lerp(a, b, t)!;
      return PrettyQrBrush.solid(lerpedColor.value);
    }

    return PrettyQrBrush.gradient(gradient: a.gradient.lerpToColor(b, t));
  }
}

/// A single color QR Code brush.
@sealed
@immutable
class PrettyQrSolidBrush extends PrettyQrBrush {
  /// {@template pretty_qr_code.painting.PrettyQrSolidBrush}
  /// Creates a solid brush.
  /// {@endtemplate}
  @literal
  const PrettyQrSolidBrush(super.value);

  @override
  Paint toPaint(Rect rect, {TextDirection? textDirection}) {
    return Paint()
      ..color = this
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
  }

  @override
  int get hashCode {
    return value.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrSolidBrush && other.value == value;
  }
}

/// A gradient QR Code brush.
@sealed
@immutable
class PrettyQrGradientBrush extends PrettyQrBrush {
  /// A gradient to use when filling the QR Code shape.
  @nonVirtual
  final Gradient gradient;

  /// {@template pretty_qr_code.painting.PrettyQrGradientBrush}
  /// Creates a brush from [gradient].
  /// {@endtemplate}
  @literal
  const PrettyQrGradientBrush({
    required this.gradient,
  }) : super(0x00000000);

  @override
  int get value {
    final iterator = gradient.colors.iterator;
    if (iterator.moveNext()) return iterator.current.value;
    return super.value;
  }

  @override
  Paint toPaint(Rect rect, {TextDirection? textDirection}) {
    return Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(rect, textDirection: textDirection);
  }

  @override
  int get hashCode {
    return gradient.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrGradientBrush && other.gradient == gradient;
  }
}
