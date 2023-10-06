import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

extension PrettyQrImageExtension on QrImage {
  /// Whether or not this [QrImage], can be saved as file.
  bool get supportsSaving => true;

  Future<void> exportAsImage(
    final BuildContext context, {
    required final int size,
    final PrettyQrDecoration decoration = const PrettyQrDecoration(),
  }) async {
    final bytes = await toImageAsBytes(
      size: size,
      decoration: decoration,
      configuration: createLocalImageConfiguration(context),
    );

    await ImageGallerySaver.saveImage(bytes!.buffer.asUint8List());
  }
}
