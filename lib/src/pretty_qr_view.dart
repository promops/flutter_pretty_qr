import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_render_view.dart';

/// {@macro pretty_qr_code.PrettyQrView}
@Deprecated('Use `PrettyQrView` instead')
typedef PrettyQr = PrettyQrView;

/// {@template pretty_qr_code.PrettyQrView}
/// TODO: `PrettyQrView` description
/// {@endtemplate}
@sealed
class PrettyQrView extends SingleChildRenderObjectWidget {
  /// {@macro pretty_qr_code.PrettyQrRenderView.qrImage}
  @protected
  final QrImage qrImage;

  /// {@macro pretty_qr_code.PrettyQrRenderView.decoration}
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
  PrettyQrRenderView createRenderObject(BuildContext context) {
    return PrettyQrRenderView(
      qrImage: qrImage,
      decoration: decoration,
      configuration: createLocalImageConfiguration(context),
    );
  }

  @override
  void updateRenderObject(
    final BuildContext context,
    final PrettyQrRenderView renderObject,
  ) {
    renderObject
      ..qrImage = qrImage
      ..decoration = decoration
      ..configuration = createLocalImageConfiguration(context);
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
