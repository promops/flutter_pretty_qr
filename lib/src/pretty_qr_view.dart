import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/rendering/render_pretty_qr_view.dart';

/// {@macro pretty_qr_code.PrettyQrView}
@Deprecated('Use `PrettyQrView` instead')
typedef PrettyQr = PrettyQrView;

/// {@template pretty_qr_code.PrettyQrView}
/// TODO: `PrettyQrView` description
/// {@endtemplate}
@sealed
class PrettyQrView extends SingleChildRenderObjectWidget {
  /// {@macro pretty_qr_code.RenderPrettyQrView.qrImage}
  @protected
  final QrImage qrImage;

  /// {@macro pretty_qr_code.RenderPrettyQrView.decoration}
  @protected
  final PrettyQrDecoration decoration;

  /// Creates a widget that displays an QR image obtained from a [code].
  @literal
  const PrettyQrView({
    required this.qrImage,
    super.key,
    super.child,
    this.decoration = const PrettyQrDecoration(),
  });

  /// Creates a widget that displays an QR image obtained from a [data].
  factory PrettyQrView.data({
    required final String data,
    final Key? key,
    final Widget? child,
    final int errorCorrectLevel = QrErrorCorrectLevel.L,
    final PrettyQrDecoration decoration = const PrettyQrDecoration(),
  }) {
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: errorCorrectLevel,
    );

    return PrettyQrView(
      key: key,
      qrImage: QrImage(qrCode),
      decoration: decoration,
      child: child,
    );
  }

  @override
  RenderPrettyQrView createRenderObject(BuildContext context) {
    return RenderPrettyQrView(
      qrImage: qrImage,
      decoration: decoration,
    );
  }

  @override
  void updateRenderObject(
    final BuildContext context,
    final RenderPrettyQrView renderObject,
  ) {
    renderObject
      ..qrImage = qrImage
      ..decoration = decoration;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(DiagnosticsProperty<PrettyQrDecoration>(
      'decoration',
      decoration,
    ));
  }
}
