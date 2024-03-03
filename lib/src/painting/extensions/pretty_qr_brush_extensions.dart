import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';

/// Extensions that apply to [Gradient].
@internal
extension PrettyQrBrushGradientExtension on Gradient {
  /// Linearly interpolates from `this` to [Color].
  Gradient lerpToColor(Color color, double t) {
    final gradient = this;
    if (gradient is LinearGradient) {
      return LinearGradient(
        begin: gradient.begin,
        end: gradient.end,
        stops: gradient.stops,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
        colors: [...colors.map((a) => Color.lerp(a, color, t)!)],
      );
    } else if (gradient is RadialGradient) {
      return RadialGradient(
        center: gradient.center,
        radius: gradient.radius,
        stops: gradient.stops,
        focal: gradient.focal,
        focalRadius: gradient.focalRadius,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
        colors: [...colors.map((a) => Color.lerp(a, color, t)!)],
      );
    } else if (gradient is SweepGradient) {
      return SweepGradient(
        center: gradient.center,
        startAngle: gradient.startAngle,
        endAngle: gradient.endAngle,
        stops: gradient.stops,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
        colors: [...colors.map((a) => Color.lerp(a, color, t)!)],
      );
    }
    return t < 0.5 ? gradient : LinearGradient(colors: [color, color]);
  }
}

/// Extensions that apply to [Color].
@internal
extension PrettyQrColorBrushGradientExtension on Color {
  /// Linearly interpolates from `this` to [Gradient].
  Gradient lerpToGradient(Gradient gradient, double t) {
    if (gradient is LinearGradient) {
      return LinearGradient(
        begin: gradient.begin,
        end: gradient.end,
        stops: gradient.stops,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
        colors: [...gradient.colors.map((b) => Color.lerp(this, b, t)!)],
      );
    } else if (gradient is RadialGradient) {
      return RadialGradient(
        center: gradient.center,
        radius: gradient.radius,
        stops: gradient.stops,
        focal: gradient.focal,
        focalRadius: gradient.focalRadius,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
        colors: [...gradient.colors.map((b) => Color.lerp(this, b, t)!)],
      );
    } else if (gradient is SweepGradient) {
      return SweepGradient(
        center: gradient.center,
        startAngle: gradient.startAngle,
        endAngle: gradient.endAngle,
        stops: gradient.stops,
        tileMode: gradient.tileMode,
        transform: gradient.transform,
        colors: [...gradient.colors.map((b) => Color.lerp(this, b, t)!)],
      );
    }
    return t < 0.5 ? LinearGradient(colors: [this, this]) : gradient;
  }
}
