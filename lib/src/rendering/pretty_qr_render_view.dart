import 'dart:math';

import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration_image.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_module_extensions.dart';

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

    final paintingContext = PrettyQrPaintingContext(
      canvas: canvas,
      bounds: Offset.zero & size,
      matrix: PrettyQrMatrix.fromQrImage(qrImage),
      textDirection: configuration.textDirection,
    );

    final image = decoration.image;
    if (image != null) {
      final imageRect = Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width * image.scale,
        height: size.height * image.scale,
      );

      final imagePadding = image.padding.resolve(
        configuration.textDirection,
      );

      // clear space for the embedded image
      if (image.position == PrettyQrDecorationImagePosition.embedded) {
        final imageClippedRect = imagePadding.inflateRect(imageRect);
        for (final module in paintingContext.matrix) {
          final moduleRect = module.resolve(paintingContext);

          if (imageClippedRect.overlaps(moduleRect)) {
            paintingContext.matrix.removeDarkAt(module.x, module.y);
          }
        }
      }

      if (image.position == PrettyQrDecorationImagePosition.foreground) {
        decoration.shape.paint(paintingContext);
      }

      _decorationImagePainter ??= image.createPainter(markNeedsPaint);
      _decorationImagePainter?.paint(canvas, imageRect, null, configuration);
    }

    if (image?.position != PrettyQrDecorationImagePosition.foreground) {
      decoration.shape.paint(paintingContext);
    }

    canvas.restore();
    super.paint(context, offset);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<ImageConfiguration>(
        'configuration',
        configuration,
      ))
      ..add(DiagnosticsProperty<QrImage>('qrImage', qrImage))
      ..add(decoration.toDiagnosticsNode(name: 'decoration'));
  }

  @override
  void dispose() {
    _decorationImagePainter?.dispose();

    super.dispose();
  }
}
