import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

/// {@template pretty_qr_code.painting.PrettyQrDecorationImagePosition}
/// Where to paint a image decoration.
/// {@endtemplate}
enum PrettyQrDecorationImagePosition {
  /// Paint the image decoration inside the QR code.
  embedded,

  /// Paint the image decoration behind the QR code.
  background,

  /// Paint the image decoration in front of the QR code.
  foreground,
}

/// An image for a QR decoration.
@immutable
class PrettyQrDecorationImage extends DecorationImage {
  /// The padding for the QR image.
  @nonVirtual
  final EdgeInsetsGeometry padding;

  /// {@macro pretty_qr_code.painting.PrettyQrDecorationImagePosition}
  final PrettyQrDecorationImagePosition position;

  /// Creates an image to show into QR code.
  ///
  /// Not recommended to use scale over `0.2`, see the
  /// [qr code error correction feature](https://www.qrcode.com/en/about/error_correction.html).
  @literal
  const PrettyQrDecorationImage({
    required super.image,
    super.scale = 0.2,
    super.onError,
    super.colorFilter,
    super.fit,
    super.repeat = ImageRepeat.noRepeat,
    super.matchTextDirection = false,
    super.opacity = 1.0,
    super.filterQuality = FilterQuality.low,
    super.invertColors = false,
    super.isAntiAlias = false,
    this.padding = EdgeInsets.zero,
    this.position = PrettyQrDecorationImagePosition.embedded,
  }) : assert(scale >= 0 && scale <= 1);

  /// Creates a copy of this [PrettyQrDecorationImage] but with the given fields
  /// replaced with the new values.
  @factory
  @useResult
  PrettyQrDecorationImage copyWith({
    final ImageProvider? image,
    final double? scale,
    final ImageErrorListener? onError,
    final ColorFilter? colorFilter,
    final BoxFit? fit,
    final ImageRepeat? repeat,
    final bool? matchTextDirection,
    final double? opacity,
    final FilterQuality? filterQuality,
    final bool? invertColors,
    final bool? isAntiAlias,
    final EdgeInsetsGeometry? padding,
    final PrettyQrDecorationImagePosition? position,
  }) {
    return PrettyQrDecorationImage(
      image: image ?? this.image,
      scale: scale ?? this.scale,
      onError: onError ?? this.onError,
      colorFilter: colorFilter ?? this.colorFilter,
      fit: fit ?? this.fit,
      repeat: repeat ?? this.repeat,
      matchTextDirection: matchTextDirection ?? this.matchTextDirection,
      opacity: opacity ?? this.opacity,
      filterQuality: filterQuality ?? this.filterQuality,
      invertColors: invertColors ?? this.invertColors,
      isAntiAlias: isAntiAlias ?? this.isAntiAlias,
      padding: padding ?? this.padding,
      position: position ?? this.position,
    );
  }

  /// Linearly interpolates between two [PrettyQrDecorationImage]s.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static PrettyQrDecorationImage? lerp(
    final PrettyQrDecorationImage? a,
    final PrettyQrDecorationImage? b,
    final double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a != null && b != null) {
      if (t == 0.0) return a;
      if (t == 1.0) return b;
    }

    if (a == null) {
      return b?.copyWith(
        scale: b.scale * t,
        opacity: b.opacity * t,
        padding: EdgeInsetsGeometry.lerp(null, b.padding, t)!,
      );
    }

    if (b == null) {
      return a.copyWith(
        scale: a.scale * (1.0 - t),
        opacity: a.opacity * (1.0 - t),
        padding: EdgeInsetsGeometry.lerp(a.padding, null, t)!,
      );
    }

    return (t < 0.5 ? a : b).copyWith(
      scale: lerpDouble(a.scale, b.scale, t)!,
      opacity: lerpDouble(a.opacity, b.opacity, t)!,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
    );
  }

  @override
  int get hashCode {
    return super.hashCode ^ Object.hash(runtimeType, padding);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrDecorationImage &&
        super == other &&
        other.padding == padding &&
        other.position == position;
  }
}
