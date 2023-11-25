import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_shape.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_module_extensions.dart';

/// A rectangular symbol with rounded corners.
@sealed
class PrettyQrRoundedSymbol extends PrettyQrShape {
  /// The color of QR Code symbol.
  @nonVirtual
  final Color color;

  /// If non-null, the corners of QR modules are rounded by this [BorderRadius].
  @nonVirtual
  final BorderRadiusGeometry borderRadius;

  /// The default value for [borderRadius].
  static const kDefaultBorderRadius = BorderRadius.all(
    Radius.circular(8),
  );

  /// Creates a basic QR shape.
  @literal
  const PrettyQrRoundedSymbol({
    this.color = const Color(0xFF000000),
    this.borderRadius = kDefaultBorderRadius,
  });

  @override
  void paint(PrettyQrPaintingContext context) {
    final path = Path();
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    final radius = borderRadius.resolve(context.textDirection);

    for (final module in context.matrix) {
      if (!module.isDark) continue;

      final modulePath = Path();
      final moduleRect = module.resolveRect(context);
      modulePath.addRRect(radius.toRRect(moduleRect));

      if (context.isImpellerEngineEnabled) {
        context.canvas.drawPath(modulePath, paint);
      } else {
        path.addPath(modulePath, Offset.zero);
      }
    }

    context.canvas.drawPath(path, paint);
  }

  @override
  PrettyQrRoundedSymbol? lerpFrom(PrettyQrShape? a, double t) {
    if (identical(a, this)) {
      return this;
    }

    if (a == null) return this;
    if (a is! PrettyQrRoundedSymbol) return null;

    if (t == 0.0) return a;
    if (t == 1.0) return this;

    return PrettyQrRoundedSymbol(
      color: Color.lerp(a.color, color, t)!,
      borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
    );
  }

  @override
  PrettyQrRoundedSymbol? lerpTo(PrettyQrShape? b, double t) {
    if (identical(this, b)) {
      return this;
    }

    if (b == null) return this;
    if (b is! PrettyQrRoundedSymbol) return null;

    if (t == 0.0) return this;
    if (t == 1.0) return b;

    return PrettyQrRoundedSymbol(
      color: Color.lerp(color, b.color, t)!,
      borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
    );
  }

  @override
  int get hashCode {
    return runtimeType.hashCode ^ Object.hash(color, borderRadius);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is PrettyQrRoundedSymbol &&
        other.color == color &&
        other.borderRadius == borderRadius;
  }
}
