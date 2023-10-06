import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';
import 'package:qr/qr.dart';
import 'package:flutter/rendering.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_painter.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

/// Extensions that apply to QR Image.
extension PrettyQrImageExtension on QrImage {
  /// Returns the QR Code image.
  Future<ui.Image> toImage({
    required final int size,
    final PrettyQrDecoration decoration = const PrettyQrDecoration(),
    final ImageConfiguration configuration = ImageConfiguration.empty,
  }) {
    final imageSize = Size.square(size.toDouble());
    final imageCompleter = Completer<ui.Image>();
    final pictureRecorder = ui.PictureRecorder();
    final imageConfiguration = configuration.copyWith(size: imageSize);

    final context = PrettyQrPaintingContext(
      Canvas(pictureRecorder),
      Offset.zero & imageSize,
      matrix: PrettyQrMatrix.fromQrImage(this),
      textDirection: configuration.textDirection,
    );

    void captureQRImage() {
      final picture = pictureRecorder.endRecording();
      imageCompleter.complete(picture.toImage(size, size));
    }

    late final PrettyQrPainter decorationPainter;
    try {
      decorationPainter = decoration.createPainter(() {
        decorationPainter.paint(context, imageConfiguration);
        captureQRImage();
      });
      decorationPainter.paint(context, imageConfiguration);

      final decorationImageStream = decoration.image?.image.resolve(
        configuration,
      );

      if (decorationImageStream == null) {
        captureQRImage();
      } else {
        late final ImageStreamListener imageStreamListener;
        imageStreamListener = ImageStreamListener(
          (imageInfo, synchronous) {
            decorationImageStream.removeListener(imageStreamListener);
            imageInfo.dispose();
            if (synchronous) captureQRImage();
          },
          onError: (error, stackTrace) {
            decorationImageStream.removeListener(imageStreamListener);
            imageCompleter.completeError(error, stackTrace);
          },
        );
        decorationImageStream.addListener(imageStreamListener);
      }
    } catch (error, stackTrace) {
      imageCompleter.completeError(error, stackTrace);
    }

    return imageCompleter.future.whenComplete(() {
      decorationPainter.dispose();
    });
  }

  /// Returns the QR Code image as a list of bytes.
  Future<ByteData?> toImageAsBytes({
    required final int size,
    final ui.ImageByteFormat format = ui.ImageByteFormat.png,
    final PrettyQrDecoration decoration = const PrettyQrDecoration(),
    final ImageConfiguration configuration = ImageConfiguration.empty,
  }) async {
    final image = await toImage(
      size: size,
      decoration: decoration,
      configuration: configuration,
    );
    return image.toByteData(format: format);
  }
}
