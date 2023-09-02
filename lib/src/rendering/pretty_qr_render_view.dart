import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration_image.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_module_extensions.dart';

/// {@template pretty_qr_code.PrettyQrRenderView}
/// An QR code image in the render tree.
/// {@endtemplate}
@sealed
@internal
class PrettyQrRenderView extends RenderBox {
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

  /// The QR code image raster size.
  @protected
  Size? _cachedQRImageSize;

  /// The QR code image raster.
  @protected
  ui.Image? _cachedQRImageRaster;

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
  void markNeedsPaint() {
    _resetCachedRaster();
    super.markNeedsPaint();
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
    final size = Size.square(
      configuration.size?.shortestSide ?? this.size.shortestSide,
    );

    if (_cachedQRImageSize != null && _cachedQRImageSize != size) {
      _resetCachedRaster();
    }

    if (_cachedQRImageRaster != null) {
      context.setIsComplexHint();
      return _paintCachedRaster(context, offset);
    }

    final offsetLayer = OffsetLayer();
    final paintingContext = PrettyQrPaintingContext(
      offsetLayer,
      Offset.zero & size,
      matrix: PrettyQrMatrix.fromQrImage(qrImage),
      textDirection: configuration.textDirection,
    );

    final image = decoration.image;
    if (image != null) {
      final imageScale = image.scale.clamp(0.0, 1.0);
      final imageRect = Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width * imageScale,
        height: size.height * imageScale,
      );

      // clear space for the embedded image
      if (image.position == PrettyQrDecorationImagePosition.embedded) {
        for (final module in paintingContext.matrix) {
          final moduleRect = module.resolve(paintingContext);
          if (imageRect.overlaps(moduleRect)) {
            paintingContext.matrix.removeDarkAt(module.x, module.y);
          }
        }
      }

      if (image.position == PrettyQrDecorationImagePosition.foreground) {
        decoration.shape.paint(paintingContext);
      }

      final imagePadding = (image.padding * imageScale).resolve(
        configuration.textDirection,
      );
      final imageCroppedRect = imagePadding.deflateRect(imageRect);

      _decorationImagePainter ??= image.createPainter(markNeedsPaint);
      _decorationImagePainter?.paint(
        paintingContext.canvas,
        imageCroppedRect,
        null,
        configuration.copyWith(size: imageCroppedRect.size),
      );
    }

    if (image?.position != PrettyQrDecorationImagePosition.foreground) {
      decoration.shape.paint(paintingContext);
    }

    // ignore: invalid_use_of_protected_member, see `SnapshotWidget`
    paintingContext.stopRecordingIfNeeded();

    _cachedQRImageRaster = offsetLayer.toImageSync(
      paintingContext.estimatedBounds,
      pixelRatio: configuration.devicePixelRatio!,
    );
    _cachedQRImageSize = size;

    offsetLayer.dispose();
    _paintCachedRaster(context, offset);
  }

  @protected
  void _paintCachedRaster(PaintingContext context, Offset offset) {
    final cachedQRImageSize = _cachedQRImageSize;
    final cachedQRImageRaster = _cachedQRImageRaster;

    if (cachedQRImageSize == null) return;
    if (cachedQRImageRaster == null) return;

    context.canvas.drawImageRect(
      cachedQRImageRaster,
      Rect.fromLTWH(
        0,
        0,
        cachedQRImageRaster.width.toDouble(),
        cachedQRImageRaster.height.toDouble(),
      ),
      Rect.fromCenter(
        center: size.center(offset),
        width: cachedQRImageSize.width,
        height: cachedQRImageSize.height,
      ),
      Paint()..filterQuality = FilterQuality.low,
    );
  }

  @protected
  void _resetCachedRaster() {
    _cachedQRImageRaster?.dispose();

    _cachedQRImageSize = null;
    _cachedQRImageRaster = null;
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
  void detach() {
    _resetCachedRaster();
    super.detach();
  }

  @override
  void dispose() {
    _resetCachedRaster();
    _decorationImagePainter?.dispose();

    super.dispose();
  }
}
