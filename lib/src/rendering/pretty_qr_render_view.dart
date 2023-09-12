import 'dart:math' as math;

import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_painter.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

/// {@template pretty_qr_code.PrettyQrRenderView}
/// An QR code image in the render tree.
/// {@endtemplate}
@internal
class PrettyQrRenderView extends RenderBox {
  /// {@template pretty_qr_code.PrettyQrRenderView.qrImage}
  /// The QR to display.
  /// {@endtemplate}
  @nonVirtual
  late QrImage _qrImage;

  /// {@template pretty_qr_code.PrettyQrRenderView.decoration}
  /// What decoration to paint.
  /// {@endtemplate}
  @nonVirtual
  late PrettyQrDecoration _decoration;

  /// {@template pretty_qr_code.PrettyQrRenderView.configuration}
  /// The settings to pass to the decoration when painting, so that it can
  /// resolve images appropriately. See [ImageProvider.resolve].
  /// {@endtemplate}
  @nonVirtual
  late ImageConfiguration _configuration;

  /// The painter for a [PrettyQrPainter].
  @protected
  PrettyQrPainter? _decorationPainter;

  /// Creates a QR view.
  PrettyQrRenderView({
    required QrImage qrImage,
    required PrettyQrDecoration decoration,
    final ImageConfiguration configuration = ImageConfiguration.empty,
  })  : _qrImage = qrImage,
        _decoration = decoration,
        _configuration = configuration;

  /// {@macro pretty_qr_code.PrettyQrRenderView.qrImage}
  QrImage get qrImage {
    return _qrImage;
  }

  /// Sets the qr image.
  set qrImage(QrImage value) {
    if (_qrImage == value) return;

    _qrImage = value;
    markNeedsPaint();
  }

  /// {@macro pretty_qr_code.PrettyQrRenderView.decoration}
  PrettyQrDecoration get decoration {
    return _decoration;
  }

  /// Sets the current decoration.
  set decoration(PrettyQrDecoration value) {
    if (_decoration == value) return;

    _decorationPainter?.dispose();
    _decorationPainter = null;

    _decoration = value;
    markNeedsPaint();
  }

  /// {@macro pretty_qr_code.PrettyQrRenderView.configuration}
  ImageConfiguration get configuration {
    return _configuration;
  }

  /// Sets the image configuration.
  set configuration(ImageConfiguration value) {
    if (value == _configuration) return;

    _configuration = value;
    markNeedsPaint();
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void performLayout() {
    size = _sizeForConstraints(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _sizeForConstraints(constraints);
  }

  /// Find a size for the QR image within the given constraints.
  @protected
  Size _sizeForConstraints(BoxConstraints constraints) {
    final minDimension = math.min(constraints.maxWidth, constraints.maxHeight);
    return constraints.constrain(Size.square(minDimension));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    if (offset != Offset.zero) {
      context.canvas.translate(offset.dx, offset.dy);
    }

    try {
      final size = Size.square(
        configuration.size?.shortestSide ?? this.size.shortestSide,
      );

      final paintingContext = PrettyQrPaintingContext(
        context.canvas,
        Offset.zero & size,
        matrix: PrettyQrMatrix.fromQrImage(qrImage),
        textDirection: configuration.textDirection,
      );

      _decorationPainter ??= decoration.createPainter(markNeedsPaint);
      _decorationPainter?.paint(paintingContext, configuration);
    } finally {
      context.canvas.restore();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<ImageConfiguration>(
          'configuration',
          configuration,
        ),
      )
      ..add(DiagnosticsProperty<QrImage>('qrImage', qrImage))
      ..add(decoration.toDiagnosticsNode(name: 'decoration'));
  }

  @override
  void dispose() {
    _decorationPainter?.dispose();

    super.dispose();
  }
}
