// import 'dart:async';

// import 'package:pretty_qr_code/src/painting/pretty_qr_decoration.dart';
// import 'package:pretty_qr_code/old/pretty_qr_painter.dart';
// import 'package:qr/qr.dart';
// import 'package:meta/meta.dart';
// import 'package:flutter/widgets.dart';
// import 'dart:ui' as ui;

// typedef PrettyQr = PrettyQrView;

// @sealed
// class PrettyQrView extends StatefulWidget {
//   /// The QR to display.
//   @protected
//   final QrImage code;

//   /// What decoration to paint.
//   @protected
//   final PrettyQrDecoration decoration;

//   /// Creates a widget that displays an QR image obtained from a [code].
//   @literal
//   const PrettyQrView({
//     required this.code,
//     super.key,
//     this.decoration = const PrettyQrDecoration(),
//   });

//   @override
//   State<PrettyQrView> createState() => _PrettyQrViewState();
// }

// @sealed
// class _PrettyQrViewState extends State<PrettyQrView> {
//   Completer<ui.Image>? imageCompleter;

//   @override
//   void initState() {
//     super.initState();

//     imageCompleter = resolveImage();
//   }

//   @override
//   void didUpdateWidget(covariant PrettyQrView oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (oldWidget.decoration == widget.decoration) return;
//     if (oldWidget.decoration.image != widget.decoration.image) {
//       imageCompleter = resolveImage();
//     }
//   }

//   @protected
//   Completer<ui.Image>? resolveImage() {
//     final image = widget.decoration.image?.image;
//     if (image == null) return null;

//     final completer = Completer<ui.Image>();

//     final stream = image.resolve(ImageConfiguration(
//       devicePixelRatio: ui.window.devicePixelRatio,
//     ));

//     stream.addListener(ImageStreamListener(
//       (imageInfo, error) {
//         completer.complete(imageInfo.image);
//       },
//       onError: (dynamic error, _) {
//         completer.completeError(error);
//       },
//     ));

//     return completer;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ui.Image>(
//       future: imageCompleter?.future,
//       builder: (context, snapshot) {
//         return LayoutBuilder(builder: (context, constr) {
//           print(constr);
//           return CustomPaint(
//             painter: PrettyQrCodePainter(
//               qrImage: widget.code,
//               image: snapshot.data,
//               decoration: widget.decoration,
//             ),
//           );
//         });
//       },
//     );
//   }
// }
