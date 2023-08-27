import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';
import 'package:pretty_qr_code/src/interface/pretty_qr_decoration_image.dart';
import 'package:pretty_qr_code/src/painter/default_painter.dart';

import 'pretty_qr_shape_dots.dart';

/// An immutable description of how to paint a QR image.
/// TODO: with Diagnosticable
@immutable
class PrettyQrDecoration {
  /// The color of QR dots.
  @nonVirtual
  final Color color;

  /// The QR dots shape.
  @nonVirtual
  final PrettyQrShapeDots shape;

  /// The image will be embed to the center of the QR code.
  @nonVirtual
  final PrettyQrDecorationImage? image;

  /// Creates a QR image decoration.
  @literal
  const PrettyQrDecoration({
    this.image,
    this.color = const Color(0xFF000000),
    this.shape = const PrettyQrDefaultDots(),
  });

  /// Creates a copy of this [PrettyQrDecoration] but with the given fields
  /// replaced with the new values.
  @factory
  @useResult
  PrettyQrDecoration copyWith({
    final Color? color,
    final PrettyQrShapeDots? shape,
    final PrettyQrDecorationImage? image,
  }) {
    return PrettyQrDecoration(
      color: color ?? this.color,
      image: image ?? this.image,
      shape: shape ?? this.shape,
    );
  }

  /// Linearly interpolates between two [PrettyQrDecoration]s.
  @factory
  static PrettyQrDecoration? lerp(
    final PrettyQrDecoration? a,
    final PrettyQrDecoration? b,
    final double t,
  ) {
    // TODO: implement lerp
    // для PrettyQrShapeDots тоже, тогда можно будет красиво их менять
    return const PrettyQrDecoration();
  }

  @override
  int get hashCode {
    return runtimeType.hashCode ^ Object.hash(color, shape, image);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrDecoration &&
        color == other.color &&
        image == other.image &&
        shape == other.shape;
  }
}
