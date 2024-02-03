import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:pretty_qr_code/src/widgets/pretty_qr_data_view.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_render_view.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration.dart';

/// {@template pretty_qr_code.widgets.PrettyQrView}
/// A widget that displays a QR code symbol.
/// {@endtemplate}
///
/// {@tool snippet}
///
/// This sample code shows how to use `PrettyQrView` to display QR code image.
///
/// ```dart
/// PrettyQrView.data(
///   data: '...',
///   errorCorrectLevel: QrErrorCorrectLevel.H,
///   decoration: const PrettyQrDecoration(
///     shape: PrettyQrSmoothSymbol(),
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
  /// {@macro pretty_qr_code.rendering.PrettyQrRenderView.qrImage}
  @protected
  final QrImage qrImage;

  /// {@macro pretty_qr_code.rendering.PrettyQrRenderView.decoration}
  @protected
  final PrettyQrDecoration decoration;

  /// Creates a widget that displays an QR symbol obtained from a [qrImage].
  @literal
  const PrettyQrView({
    required this.qrImage,
    super.key,
    this.decoration = const PrettyQrDecoration(),
  });

  /// Creates a widget that displays an QR symbol obtained from a [data].
  @factory
  static PrettyQrDataView data({
    required final String data,
    final Key? key,
    final int errorCorrectLevel = QrErrorCorrectLevel.L,
    final PrettyQrDecoration decoration = const PrettyQrDecoration(),
    final ImageErrorWidgetBuilder? errorBuilder,
  }) {
    return PrettyQrDataView(
      key: key,
      data: data,
      decoration: decoration,
      errorCorrectLevel: errorCorrectLevel,
      errorBuilder: errorBuilder,
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
    // ignore: avoid-mutating-parameters, updates the current render object.
    renderObject
      ..qrImage = qrImage
      ..decoration = decoration
      ..configuration = createLocalImageConfiguration(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<QrImage>('qrImage', qrImage))
      ..add(DiagnosticsProperty<PrettyQrDecoration>('decoration', decoration));
  }
}
