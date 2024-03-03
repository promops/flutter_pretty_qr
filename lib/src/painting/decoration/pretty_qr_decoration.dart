import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_brush.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_shape.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_painter.dart';
import 'package:pretty_qr_code/src/painting/shapes/pretty_qr_smooth_symbol.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration_image.dart';

/// {@template pretty_qr_code.painting.PrettyQrDecoration}
/// An immutable description of how to paint a QR image.
/// {@endtemplate}
@immutable
class PrettyQrDecoration with Diagnosticable {
  /// The QR modules shape.
  @nonVirtual
  final PrettyQrShape shape;

  /// The color or brush to fill in the background of the QR code.
  @nonVirtual
  final Color? background;

  /// The image will be embed to the center of the QR code.
  @nonVirtual
  final PrettyQrDecorationImage? image;

  /// The default QR code shape.
  ///
  /// This value is used by default to paint QR codes.
  @Deprecated(
    'Please use `PrettyQrTheme.fallback` instead. '
    'This feature was deprecated after v3.3.0.',
  )
  static const kDefaultDecorationShape = PrettyQrSmoothSymbol();

  /// Creates a QR image decoration.
  @literal
  const PrettyQrDecoration({
    // ignore: deprecated_member_use_from_same_package, backward compatibility.
    this.shape = kDefaultDecorationShape,
    this.background,
    this.image,
  });

  @override
  String toStringShort() {
    return objectRuntimeType(this, 'PrettyQrDecoration');
  }

  /// Creates a copy of this [PrettyQrDecoration] but with the given fields
  /// replaced with the new values.
  @factory
  @useResult
  PrettyQrDecoration copyWith({
    final PrettyQrShape? shape,
    final Color? background,
    final PrettyQrDecorationImage? image,
  }) {
    return PrettyQrDecoration(
      shape: shape ?? this.shape,
      background: background ?? this.background,
      image: image ?? this.image,
    );
  }

  /// Returns a [PrettyQrPainter] that will paint QR code with this decoration.
  @nonVirtual
  PrettyQrPainter createPainter(VoidCallback onChanged) {
    return PrettyQrPainter(decoration: this, onChanged: onChanged);
  }

  /// Linearly interpolates between two [PrettyQrDecoration]s.
  ///
  /// {@macro dart.ui.shadow.lerp}
  @factory
  static PrettyQrDecoration? lerp(
    final PrettyQrDecoration? a,
    final PrettyQrDecoration? b,
    final double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a != null && b != null) {
      if (t == 0.0) return a;
      if (t == 1.0) return b;
    }

    return PrettyQrDecoration(
      shape: PrettyQrShape.lerp(a?.shape, b?.shape, t)!,
      background: PrettyQrBrush.lerp(a?.background, b?.background, t),
      image: PrettyQrDecorationImage.lerp(a?.image, b?.image, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('shape', shape))
      ..add(DiagnosticsProperty('background', background, defaultValue: null))
      ..add(DiagnosticsProperty('image', image, defaultValue: null));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, shape, background, image);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrDecoration &&
        other.shape == shape &&
        other.background == background &&
        other.image == image;
  }
}
