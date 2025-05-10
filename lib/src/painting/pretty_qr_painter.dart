import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';

import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_brush.dart';

import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration_image.dart';

import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_module_extensions.dart';
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
    if (image != null) {
      final size = context.estimatedBounds.size;
      final imageScale = image.scale.clamp(0.0, 1.0);
      final imageScaledRect = Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width * imageScale,
        height: size.height * imageScale,
      );
      final imageRRect = image.borderRadius == null
          ? RRect.fromRectXY(imageScaledRect, 0, 0)
          : RRect.fromRectAndCorners(
              imageScaledRect,
              topLeft: image.borderRadius!.topLeft,
              topRight: image.borderRadius!.topRight,
              bottomLeft: image.borderRadius!.bottomLeft,
              bottomRight: image.borderRadius!.bottomRight,
            );

      // clear space for the embedded image
      if (image.position == PrettyQrDecorationImagePosition.embedded) {
        for (final module in context.matrix) {
          final moduleRect = module.resolveRect(context);
          if (imageRRect.contains(Offset(moduleRect.left, moduleRect.top)) ||
              imageRRect.contains(Offset(moduleRect.right, moduleRect.top)) ||
              imageRRect.contains(Offset(moduleRect.left, moduleRect.bottom)) ||
              imageRRect
                  .contains(Offset(moduleRect.right, moduleRect.bottom))) {
            context.matrix.removeDarkAt(module.x, module.y);
          }
        }
      }

      if (image.position == PrettyQrDecorationImagePosition.foreground) {
        decoration.shape.paint(context);
      }

      final imagePadding = (image.padding * imageScale).resolve(
        configuration.textDirection,
      );
      final imageCroppedRect = imagePadding.deflateRect(imageScaledRect);

      _decorationImagePainter ??= image.createPainter(onChanged);
      final clipPath = image.borderRadius == null ? null : Path()
        ?..addRRect(imageRRect)
        ..close();
      _decorationImagePainter?.paint(
        context.canvas,
        imageCroppedRect,
        clipPath,
        configuration.copyWith(size: imageCroppedRect.size),
      );
    }

    if (image?.position != PrettyQrDecorationImagePosition.foreground) {
      decoration.shape.paint(context);
    }
  }

  /// Discard any resources being held by the object.
  @mustCallSuper
  void dispose() {
    _decorationImagePainter?.dispose();
    _decorationImagePainter = null;
  }
}
