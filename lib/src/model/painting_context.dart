import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
import 'package:pretty_qr_code/src/model/modules_matrix.dart';

@immutable
class QrPointPaintingContext {
  final Canvas canvas;
  final ModulesMatrix modules;
  final Color color;

  QrPointPaintingContext({
    required this.canvas,
    required this.modules,
    required this.color,
  });
}
