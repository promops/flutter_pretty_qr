import 'dart:math';

import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';

import 'package:pretty_qr_code/src/model/modules_matrix.dart';
import 'package:pretty_qr_code/src/model/painting_context.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';

/// {@template pretty_qr_code.RenderPrettyQrView}
/// Paints a [PrettyQrDecoration] either before its child paints.
/// {@endtemplate}
@sealed
class RenderPrettyQrView extends RenderProxyBox {
  /// {@template pretty_qr_code.RenderPrettyQrView.qrImage}
  /// The QR to display.
  /// {@endtemplate}
  @nonVirtual
  QrImage _qrImage;

  /// {@template pretty_qr_code.RenderPrettyQrView.decoration}
  /// What decoration to paint.
  /// {@endtemplate}
  @nonVirtual
  PrettyQrDecoration _decoration;

  /// Creates a pretty qr view.
  RenderPrettyQrView({
    required QrImage qrImage,
    required PrettyQrDecoration decoration,
    final RenderBox? child,
  })  : _qrImage = qrImage,
        _decoration = decoration,
        super(child);

  /// {@macro pretty_qr_code.RenderPrettyQrView.qrImage}
  QrImage get qrImage {
    return _qrImage;
  }

  /// Sets the current decoration.
  set qrImage(QrImage value) {
    if (_qrImage == value) return;

    _qrImage = value;
    markNeedsPaint();
  }

  /// {@macro pretty_qr_code.RenderPrettyQrView.decoration}
  PrettyQrDecoration get decoration {
    return _decoration;
  }

  /// Sets the current decoration.
  set decoration(PrettyQrDecoration value) {
    if (_decoration == value) return;

    _decoration = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // late QrPointPaintingContext context;

    // if (image != null) {
    //   final imageSize = Size(image!.width.toDouble(), image!.height.toDouble());

    //   final src = Alignment.center.inscribe(
    //     imageSize,
    //     Rect.fromLTWH(0, 0, image!.width.toDouble(), image!.height.toDouble()),
    //   );

    //   final scale = decoration.image!.scale;
    //   final rect = Rect.fromLTWH(
    //     (size.width - size.width * scale) / 2,
    //     (size.height - size.height * scale) / 2,
    //     size.width * scale,
    //     size.height * scale,
    //   );

    //   final dst = Alignment.center.inscribe(
    //     Size(size.height * scale, size.height * scale),
    //     rect,
    //   );

    //   final modules = ModulesMatrix(qrImage)..subtractRect(rect, dimension);

    //   context = QrPointPaintingContext(
    //     canvas: canvas,
    //     modules: modules,
    //     color: decoration.color,
    //     dimension: dimension,
    //   );

    //   canvas.drawImageRect(image!, src, dst, Paint());
    // } else {
    //   context = QrPointPaintingContext(
    //     canvas: canvas,
    //     modules: ModulesMatrix(qrImage),
    //     color: decoration.color,
    //     dimension: dimension,
    //   );
    // }

    final qrContext = QrPointPaintingContext(
      canvas: context.canvas,
      modules: ModulesMatrix(qrImage),
      color: decoration.color,
    );

    final dotDimension = size.shortestSide / qrImage.moduleCount;
    final firstDotRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      dotDimension,
      dotDimension,
    );

    for (var x = 0; x < qrImage.moduleCount; ++x) {
      for (var y = 0; y < qrImage.moduleCount; ++y) {
        if (qrImage.isDark(y, x)) {
          decoration.shape.paintDark(
            qrContext,
            firstDotRect.translate(dotDimension * x, dotDimension * y),
            Point(x, y),
          );
        } else {
          decoration.shape.paintWhite(
            qrContext,
            firstDotRect.translate(dotDimension * x, dotDimension * y),
            Point(x, y),
          );
        }
      }
    }
  }
}
