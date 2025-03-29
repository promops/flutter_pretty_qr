import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_qr_code/src/painting/shapes/pretty_qr_smooth_symbol.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration.dart';

/// Defines default property values for descendant [PrettyQrView] widgets.
///
/// The [PrettyQrDecoration.applyDefaults] method is used to combine a QR code
/// theme with an [PrettyQrDecoration] object.
@sealed
@immutable
class PrettyQrTheme extends ThemeExtension<PrettyQrTheme> with Diagnosticable {
  /// {@macro pretty_qr_code.painting.PrettyQrDecoration}
  @nonVirtual
  final PrettyQrDecoration decoration;

  /// The default QR code decoration.
  ///
  /// This value is used by default to paint QR codes.
  static const kDefaultDecoration = PrettyQrDecoration(
    shape: PrettyQrSmoothSymbol(),
  );

  /// Creates a QR code theme data.
  @literal
  const PrettyQrTheme({
    required this.decoration,
  });

  /// A const-constructable QR code theme that provides default decoration.
  ///
  /// Returned from [of] when the given [BuildContext] doesn't have an enclosing
  /// default QR code theme.
  @literal
  const PrettyQrTheme.fallback() : decoration = kDefaultDecoration;

  /// The closest instance of [PrettyQrTheme] that encloses the given context.
  ///
  /// If no such instance exists, returns an instance created by
  /// [PrettyQrTheme.fallback], which contains fallback values.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = PrettyQrTheme.of(context);
  /// ```
  factory PrettyQrTheme.of(
    final BuildContext context,
  ) {
    final themeExtension = Theme.of(context).extensions[PrettyQrTheme];
    // ignore: avoid-type-casts, see issue: https://github.com/flutter/flutter/issues/103313.
    return themeExtension as PrettyQrTheme? ?? const PrettyQrTheme.fallback();
  }

  /// Creates a copy of this theme with the given fields replaced by the
  /// non-null parameter values.
  @override
  PrettyQrTheme copyWith({
    final PrettyQrDecoration? decoration,
  }) {
    return PrettyQrTheme(
      decoration: decoration ?? this.decoration,
    );
  }

  /// Linearly interpolate with another [PrettyQrTheme] object.
  @override
  ThemeExtension<PrettyQrTheme> lerp(
    final ThemeExtension<PrettyQrTheme>? other,
    final double t,
  ) {
    if (other == null) return this;
    if (identical(other, this)) return this;
    if (other is! PrettyQrTheme) return this;

    if (t == 0.0) return this;
    if (t == 1.0) return other;

    return PrettyQrTheme(
      decoration: PrettyQrDecoration.lerp(decoration, other.decoration, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('decoration', decoration));
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, decoration);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is PrettyQrTheme && other.decoration == decoration;
  }
}
