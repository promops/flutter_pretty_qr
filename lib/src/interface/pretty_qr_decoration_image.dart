import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

/// An image for a QR decoration.
@immutable
class PrettyQrDecorationImage {
  /// The coefficient of the image size. Not recommended to use over `0.5`.
  @nonVirtual
  final double scale;

  /// The image to be painted into the QR decoration.
  @nonVirtual
  final ImageProvider image;

  /// The padding for the QR image.
  @nonVirtual
  final EdgeInsetsGeometry? padding;

  /// Used to combine QR dots with this image.
  /// TODO: Идея в том, чтобы можно было управлять, как изображение
  ///  накладывается на точки, но надо подумать какие варианты есть вообще
  // @nonVirtual
  // final PrettyQrDecorationImageBlendMode blendMode;

  /// Creates an image to show in a [PrettyQrDecoration].
  @literal
  const PrettyQrDecorationImage({
    required this.image,
    this.padding,
    this.scale = 0.4,
  }) : assert(scale >= 0 && scale <= 1);

  @override
  int get hashCode {
    return runtimeType.hashCode ^ Object.hash(scale, padding, image);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrDecorationImage &&
        scale == other.scale &&
        image == other.image &&
        padding == other.padding;
  }
}
