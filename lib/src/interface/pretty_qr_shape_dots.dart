import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pretty_qr_code/src/model/painting_context.dart';

/// Base class for shape QR dots.
/// TODO: Здесь лучше описывать алгоритм отрисвоки одной точки, а не всего QR
@immutable
abstract class PrettyQrShapeDots {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const PrettyQrShapeDots();

  /// Paints the [Point] on the given [Canvas].
  void paintPoint(QrPointPaintingContext context, Point<int> point);
}
