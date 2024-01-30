import 'package:flutter/material.dart';

class PrettyQrGradient {
  final List<Color> colors;
  final List<double>? stops;
  final GradientDirection direction;

  PrettyQrGradient({
    required this.colors,
    this.stops,
    this.direction = GradientDirection.topToBottom,
  });

  LinearGradient get linearGradient {
    AlignmentGeometry begin, end;
    switch (direction) {
      case GradientDirection.topToBottom:
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
        break;
      case GradientDirection.bottomToTop:
        begin = Alignment.bottomCenter;
        end = Alignment.topCenter;
        break;
      case GradientDirection.leftToRight:
        begin = Alignment.centerLeft;
        end = Alignment.centerRight;
        break;
      case GradientDirection.rightToLeft:
        begin = Alignment.centerRight;
        end = Alignment.centerLeft;
        break;
      case GradientDirection.diagonalTopLeftToBottomRight:
        begin = Alignment.topLeft;
        end = Alignment.bottomRight;
        break;
      case GradientDirection.diagonalBottomLeftToTopRight:
        begin = Alignment.bottomLeft;
        end = Alignment.topRight;
        break;
      // Adicione mais direções conforme necessário
      default:
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
    }
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
      stops: stops,
    );
  }
}


enum GradientDirection {
  topToBottom,
  bottomToTop,
  leftToRight,
  rightToLeft,
  diagonalTopLeftToBottomRight,
  diagonalBottomLeftToTopRight,
}
