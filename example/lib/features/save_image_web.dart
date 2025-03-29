import 'dart:js_interop';
import 'package:web/web.dart';

import 'package:flutter/widgets.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

extension PrettyQrImageExtension on QrImage {
  Future<String?> exportAsImage(
    final BuildContext context, {
    required final int size,
    required final PrettyQrDecoration decoration,
  }) async {
    final imageBytes = await toImageAsBytes(
      size: size,
      decoration: decoration,
      configuration: createLocalImageConfiguration(context),
    );

    final imageUrl = URL.createObjectURL(
      Blob([imageBytes!.buffer.toJS].toJS),
    );

    final saveImageAnchor = HTMLAnchorElement()
      ..href = imageUrl
      ..style.display = 'none'
      ..download = 'qr-code.png';

    document.body?.append(saveImageAnchor);
    saveImageAnchor.click();
    saveImageAnchor.remove();

    URL.revokeObjectURL(imageUrl);

    return null;
  }
}
