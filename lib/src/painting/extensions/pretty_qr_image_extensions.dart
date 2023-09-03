import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:qr/qr.dart';
import 'package:flutter/rendering.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

/// Extensions that apply to QR Image.
extension PrettyQrImageExtension on QrImage {
  /// Returns the QR Code image.
  Future<ui.Image> toImage({
    required final double size,
    final PrettyQrDecoration decoration = const PrettyQrDecoration(),
    final ImageConfiguration configuration = ImageConfiguration.empty,
  }) async {
    final offsetLayer = OffsetLayer();
    final imageCompleter = Completer<ui.Image>();
    final decorationPainter = decoration.createPainter(() {});

    final context = PrettyQrPaintingContext(
      offsetLayer,
      offsetLayer.offset & Size.square(size),
      matrix: PrettyQrMatrix.fromQrImage(this),
      textDirection: configuration.textDirection,
    );

    ui.Image captureQRImage() {
      decorationPainter.paint(
        context,
        configuration.copyWith(size: Size.square(size)),
      );

      // ignore: invalid_use_of_protected_member
      context.stopRecordingIfNeeded();

      final image = offsetLayer.toImageSync(
        context.estimatedBounds,
        pixelRatio: configuration.devicePixelRatio ?? 1.0,
      );

      return image;
    }

    final decorationImageStreamListener = ImageStreamListener(
      (imageInfo, synchronous) {
        imageCompleter.complete(captureQRImage());
        imageInfo.dispose();
      },
      onError: imageCompleter.completeError,
    );

    final decorationImageStream = decoration.image?.image.resolve(
      configuration,
    )?..addListener(decorationImageStreamListener);

    if (decorationImageStream == null) {
      imageCompleter.complete(captureQRImage());
    }

    return imageCompleter.future.then((image) {
      offsetLayer.dispose();
      decorationPainter.dispose();
      decorationImageStream?.removeListener(decorationImageStreamListener);

      return image;
    });
  }

  /// Returns the QR Code image as a list of bytes.
  Future<ByteData?> toImageAsBytes({
    required final double size,
    final ui.ImageByteFormat format = ui.ImageByteFormat.png,
    final PrettyQrDecoration decoration = const PrettyQrDecoration(),
    final ImageConfiguration configuration = ImageConfiguration.empty,
  }) async {
    final image = await toImage(
      size: size,
      decoration: decoration,
      configuration: configuration,
    );
    return await image.toByteData(format: format);
  }
}
