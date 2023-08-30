import 'dart:math';

import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

/// {@template pretty_qr_code.PrettyQrRenderView}
/// Paints a [PrettyQrDecoration] either before its child paints.
/// {@endtemplate}
@sealed
@internal
class PrettyQrRenderView extends RenderProxyBox {
  /// {@template pretty_qr_code.PrettyQrRenderView.qrImage}
  /// The QR to display.
  /// {@endtemplate}
  @nonVirtual
  QrImage _qrImage;

  /// {@template pretty_qr_code.PrettyQrRenderView.decoration}
  /// What decoration to paint.
  /// {@endtemplate}
  @nonVirtual
  PrettyQrDecoration _decoration;

  /// {@template pretty_qr_code.PrettyQrRenderView.configuration}
  /// The settings to pass to the decoration when painting, so that it can
  /// resolve images appropriately. See [ImageProvider.resolve].
  /// {@endtemplate}
  @nonVirtual
  ImageConfiguration _configuration;

  /// The painter for a [PrettyQrDecorationImage].
  @protected
  DecorationImagePainter? _decorationImagePainter;

  /// Creates a pretty qr view.
  PrettyQrRenderView({
    required QrImage qrImage,
    required PrettyQrDecoration decoration,
    final RenderBox? child,
    final ImageConfiguration configuration = ImageConfiguration.empty,
  })  : _qrImage = qrImage,
        _decoration = decoration,
        _configuration = configuration,
        super(child);

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

    if (_decoration.image?.image != value.image?.image) {
      _decorationImagePainter?.dispose();
      _decorationImagePainter = null;
    }

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
    return (Offset.zero & size).contains(position);
  }

  @override
  Size computeSizeForNoChild(BoxConstraints constraints) {
    return Size.square(min(constraints.maxWidth, constraints.maxHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    canvas.save();

    if (offset != Offset.zero) {
      canvas.translate(offset.dx, offset.dy);
    }

    final matrix = PrettyQrMatrix.fromQrImage(
      qrImage,
    );
    final paintingContext = PrettyQrPaintingContext(
      canvas: canvas,
      matrix: matrix,
      bounds: Offset.zero & size,
      textDirection: configuration.textDirection,
    );

    try {
      final decorationImage = _decoration.image;
      if (decorationImage != null) {
        // if (qrImage.errorCorrectLevel != QrErrorCorrectLevel.H) {
        //   throw ArgumentError('Error correct level "H" required to add image');
        // }

        final imageRect = Rect.fromCenter(
          center: size.center(Offset.zero),
          width: size.width * decorationImage.scale,
          height: size.height * decorationImage.scale,
        );
        final imagePadding = decorationImage.padding.resolve(
          configuration.textDirection,
        );

        final clippedRect = imagePadding.inflateRect(imageRect);
        final clippedSpace = clippedRect.width * clippedRect.height;
        final availableSpace = matrix.dimension * matrix.dimension * 0.3;

        // TODO: https://www.qrcode.com/en/about/error_correction.html
        if (clippedSpace > availableSpace.floor()) {
          // throw StateError(
          //   'Image space exceeds the maximum error correction capacity',
          // );
        }

        _decorationImagePainter ??= decorationImage.createPainter(
          markNeedsPaint,
        );

        // paintingContext.matrix.clipRect(
        //   clippedRect,
        //   size.shortestSide / qrImage.moduleCount,
        // );

        _decorationImagePainter?.paint(canvas, imageRect, null, configuration);
      }
    } finally {
      decoration.shape.paint(paintingContext);
      canvas.restore();

      super.paint(context, offset);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ImageConfiguration>(
        'configuration',
        _configuration,
      ))
      ..add(DiagnosticsProperty<QrImage>('qrImage', _qrImage))
      ..add(_decoration.toDiagnosticsNode(name: 'decoration'));
  }

  @override
  void dispose() {
    _decorationImagePainter?.dispose();

    super.dispose();
  }
}
