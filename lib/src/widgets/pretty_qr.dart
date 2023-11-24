// ignore_for_file: deprecated_member_use_from_same_package

import 'package:pretty_qr_code/src/widgets/pretty_qr_view.dart';
import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration_image.dart';
import 'package:pretty_qr_code/src/painting/shapes/pretty_qr_smooth_symbol.dart';

/// {@macro pretty_qr_code.PrettyQrView}
@Deprecated('Use `PrettyQrView.data` instead')
class PrettyQr extends StatefulWidget {
  /// Widget size.
  @nonVirtual
  final double size;

  /// Qr code data.
  @nonVirtual
  final String data;

  /// Square color.
  @nonVirtual
  final Color elementColor;

  /// Error correct level.
  @nonVirtual
  final int errorCorrectLevel;

  /// Round the corners.
  @nonVirtual
  final bool roundEdges;

  /// Number of type generation (1 to 40 or null for auto).
  @nonVirtual
  final int? typeNumber;

  /// The image to be painted into QR code.
  @nonVirtual
  final ImageProvider? image;

  @literal
  @Deprecated('Use `PrettyQrView.data` instead')
  const PrettyQr({
    required this.data,
    super.key,
    this.image,
    this.typeNumber,
    this.size = 100,
    this.roundEdges = false,
    this.elementColor = const Color(0xFF000000),
    this.errorCorrectLevel = QrErrorCorrectLevel.M,
  });

  @override
  State<PrettyQr> createState() => _PrettyQrState();
}

@sealed
class _PrettyQrState extends State<PrettyQr> {
  @protected
  late QrImage qrImage;

  @override
  void initState() {
    super.initState();
    prepareQrImage();
  }

  @override
  void didUpdateWidget(
    covariant PrettyQr oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data) {
      prepareQrImage();
    } else if (oldWidget.typeNumber != widget.typeNumber) {
      prepareQrImage();
    } else if (oldWidget.errorCorrectLevel != widget.errorCorrectLevel) {
      prepareQrImage();
    }
  }

  @protected
  void prepareQrImage() {
    if (widget.typeNumber == null) {
      final qrCode = QrCode.fromData(
        data: widget.data,
        errorCorrectLevel: widget.errorCorrectLevel,
      );

      qrImage = QrImage(qrCode);
    } else {
      final qrCode = QrCode(
        widget.typeNumber!,
        widget.errorCorrectLevel,
      )..addData(widget.data);

      qrImage = QrImage(qrCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: PrettyQrView(
        qrImage: qrImage,
        decoration: PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(
            color: widget.elementColor,
            roundFactor: widget.roundEdges ? 1 : 0,
          ),
          image: widget.image == null
              ? null
              : PrettyQrDecorationImage(
                  image: widget.image!,
                  scale: 0.25,
                  position: PrettyQrDecorationImagePosition.embedded,
                ),
        ),
      ),
    );
  }
}
