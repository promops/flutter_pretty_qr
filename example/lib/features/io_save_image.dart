import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

extension PrettyQrImageExtension on QrImage {
  Future<String?> exportAsImage(
    final BuildContext context, {
    required final int size,
    required final PrettyQrDecoration decoration,
  }) async {
    final configuration = createLocalImageConfiguration(context);
    final docDirectory = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();

    if (docDirectory == null) return null;

    final bytes = await toImageAsBytes(
      size: size,
      decoration: decoration,
      configuration: configuration,
    );

    final file = await File('${docDirectory.path}/qr.png').create();
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    return docDirectory.path;
  }
}
