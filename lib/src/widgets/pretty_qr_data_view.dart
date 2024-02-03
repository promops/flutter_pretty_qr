import 'dart:math' as math;

import 'package:qr/qr.dart';
import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

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
  @protected
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

  // ignore: no-object-declaration, Catch all types of errors
  Object? _lastError;

  @protected
  StackTrace? _lastStackTrace;

  @override
  void initState() {
    super.initState();
    _prepareQrImage();
  }

  @override
  void didUpdateWidget(
    covariant PrettyQrDataView oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data) {
      _prepareQrImage();
    } else if (oldWidget.errorCorrectLevel != widget.errorCorrectLevel) {
      _prepareQrImage();
    }
  }

  @pragma('vm:notify-debugger-on-exception')
  void _prepareQrImage() {
    try {
      final qrCode = QrCode.fromData(
        data: widget.data,
        errorCorrectLevel: widget.errorCorrectLevel,
      );
      qrImage = QrImage(qrCode);
    } on Exception catch (error, stackTrace) {
      _lastError = error;
      _lastStackTrace = stackTrace;

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
        return _PrettyQrErrorWidget(error: _lastError!);
      }
      return widget.errorBuilder!(context, _lastError!, _lastStackTrace);
    }
    return PrettyQrView(
      qrImage: qrImage,
      decoration: widget.decoration,
    );
  }
}

class _PrettyQrErrorWidget extends StatelessWidget {
  // ignore: no-object-declaration, Aall types of errors
  final Object error;

  const _PrettyQrErrorWidget({
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dimension = math.min(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        if (!kDebugMode) {
          return SizedBox.square(dimension: dimension);
        }

        return SizedBox.square(
          dimension: dimension,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned.fill(
                child: Placeholder(
                  color: Color(0xCF8D021F),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                  child: Text(
                    '$error',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      shadows: [Shadow(blurRadius: 1.0)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
