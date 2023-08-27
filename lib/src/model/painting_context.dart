import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';
import 'package:qr/qr.dart';

@immutable
class QrPointPaintingContext {
  final Canvas canvas;
  final QrImage image;

  final Color color;
  final double dimension;

  QrPointPaintingContext({
    required this.canvas,
    required this.image,
    required this.color,
    required this.dimension,
  });
}
