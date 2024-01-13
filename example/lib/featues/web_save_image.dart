import 'dart:html' as html; // ignore: avoid_web_libraries_in_flutter

import 'package:flutter/widgets.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

extension PrettyQrImageExtension on QrImage {
  Future<String?> exportAsImage(
    final BuildContext context, {
    required final int size,
    final PrettyQrDecoration decoration = const PrettyQrDecoration(),
  }) async {
    final imageBytes = await toImageAsBytes(
      size: size,
      decoration: decoration,
      configuration: createLocalImageConfiguration(context),
    );

    final imageUrl = html.Url.createObjectUrlFromBlob(
      html.Blob([imageBytes]),
    );

    final saveImageAnchor =
        html.document.createElement('a') as html.AnchorElement
          ..href = imageUrl
          ..style.display = 'none'
          ..download = 'qr-code.png';

    html.document.body?.children.add(saveImageAnchor);
    saveImageAnchor.click();

    html.Url.revokeObjectUrl(imageUrl);
    html.document.body?.children.remove(saveImageAnchor);

    return null;
  }
}
