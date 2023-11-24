import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_qr_code/src/widgets/pretty_qr_data_view.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_render_view.dart';

/// {@template pretty_qr_code.PrettyQrView}
/// A widget that displays a QR code image.
/// {@endtemplate}
///
/// {@tool snippet}
/// This sample code shows how to use `PrettyQrView` to display QR code image.
///
/// ```dart
/// PrettyQrView.data(
///   data: '...',
///   errorCorrectLevel: QrErrorCorrectLevel.H,
///   decoration: const PrettyQrDecoration(
///     shape: PrettyQrSmoothModules(),
///     image: PrettyQrDecorationImage(
///       image: AssetImage('images/flutter.png'),
///       position: PrettyQrDecorationImagePosition.embedded,
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
@sealed
class PrettyQrView extends LeafRenderObjectWidget {
  /// {@macro pretty_qr_code.PrettyQrRenderView.qrImage}
  @protected
  final QrImage qrImage;

  /// {@macro pretty_qr_code.PrettyQrRenderView.decoration}
  @protected
  final PrettyQrDecoration decoration;

  /// Creates a widget that displays an QR image obtained from a [qrImage].
  @literal
  const PrettyQrView({
    required this.qrImage,
    super.key,
    this.decoration = const PrettyQrDecoration(),
  });

  /// Creates a widget that displays an QR image obtained from a [data].
  @factory
  static PrettyQrDataView data({
    required final String data,
    final Key? key,
    final int errorCorrectLevel = QrErrorCorrectLevel.L,
    final PrettyQrDecoration decoration = const PrettyQrDecoration(),
  }) {
    return PrettyQrDataView(
      key: key,
      data: data,
      decoration: decoration,
      errorCorrectLevel: errorCorrectLevel,
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
    // ignore: avoid-mutating-parameters
    renderObject
      ..qrImage = qrImage
      ..decoration = decoration
      ..configuration = createLocalImageConfiguration(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<PrettyQrDecoration>(
          'decoration',
          decoration,
        ),
      )
      ..add(DiagnosticsProperty<QrImage>('qrImage', qrImage));
  }
}
