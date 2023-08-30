import 'package:meta/meta.dart';

import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

/// {@template pretty_qr_code.PrettyQrShape}
/// Base class for shape QR modules.
/// {@endtemplate}
@immutable
abstract class PrettyQrShape {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  @literal
  const PrettyQrShape();

  /// Linearly interpolates from another [PrettyQrShape] (which may be of a
  /// different class) to `this`.
  ///
  /// Instead of calling this directly, use [PrettyQrShape.lerp].
  PrettyQrShape? lerpFrom(PrettyQrShape? a, double t) => null;

  /// Linearly interpolates from `this` to another [PrettyQrShape] (which may be
  /// of a different class).
  ///
  /// Instead of calling this directly, use [PrettyQrShape.lerp].
  PrettyQrShape? lerpTo(PrettyQrShape? b, double t) => null;

  /// Paints the QR matrix on the canvas of the given painting context.
  void paint(PrettyQrPaintingContext context);

  /// Linearly interpolates between two [PrettyQrShape]s.
  ///
  /// This attempts to use [lerpFrom] and [lerpTo] on `b` and `a`
  /// respectively to find a solution.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static PrettyQrShape? lerp(
    final PrettyQrShape? a,
    final PrettyQrShape? b,
    final double t,
  ) {
    if (identical(a, b)) {
      return a;
    }

    if (a == null) return b!.lerpFrom(null, t) ?? b;
    if (b == null) return a.lerpTo(null, t) ?? a;

    if (t == 0.0) return a;
    if (t == 1.0) return b;

    return b.lerpFrom(a, t) ?? a.lerpTo(b, t) ?? b;
  }
}
