import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_shape.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_painter.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration_image.dart';
import 'package:pretty_qr_code/src/painting/shapes/pretty_qr_smooth_symbol.dart';

/// {@template pretty_qr_code.PrettyQrDecoration}
/// An immutable description of how to paint a QR image.
/// {@endtemplate}
@immutable
class PrettyQrDecoration with Diagnosticable {
  /// The QR modules shape.
  @nonVirtual
  final PrettyQrShape shape;

  /// The image will be embed to the center of the QR code.
  @nonVirtual
  final PrettyQrDecorationImage? image;

  /// Creates a QR image decoration.
  @literal
  const PrettyQrDecoration({
    this.image,
    this.shape = const PrettyQrSmoothSymbol(),
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
    final PrettyQrDecorationImage? image,
  }) {
    return PrettyQrDecoration(
      image: image ?? this.image,
      shape: shape ?? this.shape,
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
      image: PrettyQrDecorationImage.lerp(a?.image, b?.image, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<PrettyQrShape>(
          'shape',
          shape,
          defaultValue: const PrettyQrSmoothSymbol(),
        ),
      )
      ..add(
        DiagnosticsProperty<PrettyQrDecorationImage>(
          'image',
          image,
          defaultValue: null,
        ),
      );
  }

  @override
  int get hashCode {
    return runtimeType.hashCode ^ Object.hash(image, shape);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrDecoration &&
        other.image == image &&
        other.shape == shape;
  }
}
