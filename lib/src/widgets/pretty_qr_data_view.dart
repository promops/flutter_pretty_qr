import 'package:flutter/foundation.dart';
import 'package:pretty_qr_code/src/widgets/pretty_qr_error.dart';
import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';

import 'package:pretty_qr_code/src/widgets/pretty_qr_view.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration.dart';

/// {@macro pretty_qr_code.widgets.PrettyQrView}
@internal
class PrettyQrDataView extends StatefulWidget {
  /// The QR code data.
  @protected
  final String data;

  /// The QR code error correction level.
  @protected
  final int errorCorrectLevel;

  /// {@macro pretty_qr_code.rendering.PrettyQrRenderView.decoration}
  @protected
  final PrettyQrDecoration decoration;

  /// A builder function that is called if an error occurs during data encoding.
  ///
  /// If this builder is not provided, any exceptions will be reported to
  /// [FlutterError.onError]. If it is provided, the caller should either handle
  /// the exception by providing a replacement widget, or rethrow the exception.
  final ImageErrorWidgetBuilder? errorBuilder;

  @literal
  const PrettyQrDataView({
    required this.data,
    super.key,
    this.decoration = const PrettyQrDecoration(),
    this.errorCorrectLevel = QrErrorCorrectLevel.L,
    this.errorBuilder,
  }) : assert(errorCorrectLevel >= 0 && errorCorrectLevel <= 3);

  @override
  State<PrettyQrDataView> createState() => _PrettyQrDataViewState();
}

@sealed
class _PrettyQrDataViewState extends State<PrettyQrDataView> {
  @protected
  late QrImage qrImage;

  @protected
  // Catch all types of errors
  // ignore: no-object-declaration
  Object? _lastError;

  @protected
  StackTrace? _lastStackTrace;

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

  void _setError(Object error, StackTrace stackTrace) {
    setState(() {
      _lastError = error;
      _lastStackTrace = stackTrace;
    });
  }

  @protected
  void prepareQrImage() {
    try {
      final qrCode = QrCode.fromData(
        data: widget.data,
        errorCorrectLevel: widget.errorCorrectLevel,
      );
      qrImage = QrImage(qrCode);
    } on Exception catch (error, stackTrace) {
      _setError(error, stackTrace);
      if (widget.errorBuilder != null) {
        return;
      }

      FlutterError.reportError(
        FlutterErrorDetails(
          silent: true,
          library: 'pretty qr code',
          context: ErrorDescription('while encoding qr code'),
          exception: error,
          stack: stackTrace,
          informationCollector: () => [
            StringProperty('Data', widget.data),
            IntProperty(
              'Error correction level',
              widget.errorCorrectLevel,
              defaultValue: QrErrorCorrectLevel.L,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_lastError != null) {
      if (widget.errorBuilder == null) {
        return PrettyQrErrorWidget(error: _lastError!);
      }
      return widget.errorBuilder!(context, _lastError!, _lastStackTrace);
    }
    return PrettyQrView(
      qrImage: qrImage,
      decoration: widget.decoration,
    );
  }
}
