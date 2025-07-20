import 'dart:math';

import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';

import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_brush.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration_image.dart';
import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_quiet_zone_extension.dart';

/// A stateful class that can paint a QR code.
///
/// To obtain a painter, call [PrettyQrDecoration.createPainter].
@internal
class PrettyQrPainter {
  /// Callback that is invoked if an asynchronously-loading resource used by the
  /// decoration finishes loading. For example, an image. When this is invoked,
  /// the [paint] method should be called again.
  @nonVirtual
  final VoidCallback onChanged;

  /// What decoration to paint.
  @nonVirtual
  final PrettyQrDecoration decoration;

  /// The painter for a [PrettyQrDecorationImage].
  @protected
  DecorationImagePainter? _decorationImagePainter;

  /// Creates a QR code painter.
  PrettyQrPainter({
    required this.onChanged,
    required this.decoration,
  });

  /// Draw the QR code image onto the given canvas.
  @nonVirtual
  void paint(
    final PrettyQrPaintingContext context,
    final ImageConfiguration configuration,
  ) {
    final background = decoration.background;
    if (background != null) {
      final backgroundBrush = PrettyQrBrush.from(background);
      context.canvas.drawRect(
        context.estimatedBounds,
        backgroundBrush.toPaint(
          context.estimatedBounds,
          textDirection: context.textDirection,
        ),
      );
    }

    final quietZone = decoration.quietZone.resolveWidth(context);
    if (quietZone > 0) {
      context.canvas.translate(quietZone, quietZone);
      context.canvas.scale(1 - quietZone * 2 / context.boundsDimension);
    }

    final image = decoration.image;
    final size = context.estimatedBounds.size;

    if (image == null) {
      decoration.shape.paint(context);
      return;
    }

    if (image.position == PrettyQrDecorationImagePosition.foreground) {
      decoration.shape.paint(context);
    }

    final imageScale = image.scale.clamp(0.0, 1.0);
    final imageScaledRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * imageScale,
      height: size.height * imageScale,
    );

    final imagePadding = (image.padding * imageScale).resolve(
      configuration.textDirection,
    );
    final imageCroppedRect = imagePadding.deflateRect(imageScaledRect);

    _decorationImagePainter ??= image.createPainter(onChanged);
    _decorationImagePainter?.paint(
      context.canvas,
      imageCroppedRect,
      null,
      configuration.copyWith(size: imageCroppedRect.size),
    );

    switch (image.position) {
      case PrettyQrDecorationImagePosition.foreground:
        break; // the QR code is already drawn
      case PrettyQrDecorationImagePosition.background:
        decoration.shape.paint(context);
        return;
      case PrettyQrDecorationImagePosition.embedded:
        final moduleSize = context.boundsDimension / context.matrix.dimension;
        final clippedMatrix = PrettyQrMatrix.masked(
          context.matrix,
          clip: Rectangle(
            (imageCroppedRect.left / moduleSize).truncate(),
            (imageCroppedRect.top / moduleSize).truncate(),
            (imageCroppedRect.width / moduleSize).ceil(),
            (imageCroppedRect.height / moduleSize).ceil(),
          ),
        );
        decoration.shape.paint(context.copyWith(matrix: clippedMatrix));
    }
  }

  /// Discard any resources being held by the object.
  @mustCallSuper
  void dispose() {
    _decorationImagePainter?.dispose();
    _decorationImagePainter = null;
  }
}
