import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';

import 'package:pretty_qr_code/src/widgets/pretty_qr_view.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';

/// {@macro pretty_qr_code.PrettyQrView}
@internal
class PrettyQrDataView extends StatefulWidget {
  /// The QR code data.
  @protected
  final String data;

  /// The QR code error correction level.
  @protected
  final int errorCorrectLevel;

  /// {@macro pretty_qr_code.PrettyQrRenderView.decoration}
  @protected
  final PrettyQrDecoration decoration;

  @literal
  const PrettyQrDataView({
    required this.data,
    super.key,
    this.decoration = const PrettyQrDecoration(),
    this.errorCorrectLevel = QrErrorCorrectLevel.L,
  }) : assert(errorCorrectLevel >= 0 && errorCorrectLevel <= 3);

  @override
  State<PrettyQrDataView> createState() => _PrettyQrDataViewState();
}

@sealed
class _PrettyQrDataViewState extends State<PrettyQrDataView> {
  @protected
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();
    prepareQrImage();
  }

  @override
  void didUpdateWidget(
    covariant PrettyQrDataView oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data) {
      prepareQrImage();
    } else if (oldWidget.errorCorrectLevel != widget.errorCorrectLevel) {
      prepareQrImage();
    }
  }

  @protected
  void prepareQrImage() {
    final qrCode = QrCode.fromData(
      data: widget.data,
      errorCorrectLevel: widget.errorCorrectLevel,
    );
    qrImage = QrImage(qrCode);
  }

  @override
  Widget build(BuildContext context) {
    return PrettyQrView(
      qrImage: qrImage,
      decoration: widget.decoration,
    );
  }
}
