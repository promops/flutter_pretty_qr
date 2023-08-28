import 'dart:math';

import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/model/painting_context.dart';

/// {@template pretty_qr_code.PrettyQrShape}
/// Base class for shape QR dots.
/// {@endtemplate}
@immutable
abstract class PrettyQrShape {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  @literal
  const PrettyQrShape();

  /// Paints the [Point] on the given [Canvas].
  void paintDark(QrPointPaintingContext context, Rect rect, Point<int> point);

  /// Paints the [Point] on the given [Canvas].
  void paintWhite(QrPointPaintingContext context, Rect rect, Point<int> point);
}
