// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:pretty_qr_code/src/model/modules_matrix.dart';
// import 'package:pretty_qr_code/src/model/painting_context.dart';
// import 'dart:ui' as ui;

// class PrettyQrCodePainter extends CustomPainter {
//   final PrettyQrDecoration decoration;
//   final QrImage qrImage;
//   final ui.Image? image;

//   const PrettyQrCodePainter({
//     required this.decoration,
//     required this.qrImage,
//     this.image,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final dimension = size.shortestSide / qrImage.moduleCount;
//     late QrPointPaintingContext context;

//     if (image != null) {
//       final imageSize = Size(image!.width.toDouble(), image!.height.toDouble());

//       final src = Alignment.center.inscribe(
//         imageSize,
//         Rect.fromLTWH(0, 0, image!.width.toDouble(), image!.height.toDouble()),
//       );

//       final scale = decoration.image!.scale;
//       final rect = Rect.fromLTWH(
//         (size.width - size.width * scale) / 2,
//         (size.height - size.height * scale) / 2,
//         size.width * scale,
//         size.height * scale,
//       );

//       final dst = Alignment.center.inscribe(
//         Size(size.height * scale, size.height * scale),
//         rect,
//       );

//       final modules = ModulesMatrix(qrImage)..subtractRect(rect, dimension);

//       context = QrPointPaintingContext(
//         canvas: canvas,
//         modules: modules,
//         color: decoration.color,
//         dimension: dimension,
//       );

//       canvas.drawImageRect(image!, src, dst, Paint());
//     } else {
//       context = QrPointPaintingContext(
//         canvas: canvas,
//         modules: ModulesMatrix(qrImage),
//         color: decoration.color,
//         dimension: dimension,
//       );
//     }

//     for (int x = 0; x < qrImage.moduleCount; ++x) {
//       for (int y = 0; y < qrImage.moduleCount; ++y) {
//         decoration.shape.paintPoint(context, Point(x, y));
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(PrettyQrCodePainter oldDelegate) {
//     return oldDelegate.decoration != decoration ||
//         oldDelegate.qrImage != qrImage ||
//         oldDelegate.image != image;
//   }
// }
