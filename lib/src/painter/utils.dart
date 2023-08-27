import 'dart:math';

import 'package:pretty_qr_code/pretty_qr_code.dart';

extension RoundBorder on QrImage {
  bool isDark(int x, int y) {
    try {
      return this.isDark(x, y);
    } on ArgumentError {
      return false;
    }
  }

  bool hasPoint(Point<int> point) {
    return isDark(point.y, point.x);
  }

  bool isDot(Point<int> p) =>
      roundBottomLeft(p) && roundTopLeft(p) && roundTopRight(p) && roundBottomRight(p);

  //Out
  bool roundBottomRight(Point<int> p) => !isDark(p.y + 1, p.x) && !isDark(p.y, p.x + 1);

  bool roundTopLeft(Point<int> p) => !isDark(p.y - 1, p.x) && !isDark(p.y, p.x - 1);

  bool roundBottomLeft(Point<int> p) => !isDark(p.y + 1, p.x) && !isDark(p.y, p.x - 1);

  bool roundTopRight(Point<int> p) => !isDark(p.y - 1, p.x) && !isDark(p.y, p.x + 1);

  //Inner

  bool innerBottomRight(Point<int> p) =>
      isDark(p.y + 1, p.x) && isDark(p.y, p.x + 1) && isDark(p.y + 1, p.x + 1);

  bool innerTopLeft(Point<int> p) =>
      isDark(p.y - 1, p.x) && isDark(p.y, p.x - 1) && isDark(p.y - 1, p.x - 1);

  bool innerBottomLeft(Point<int> p) =>
      isDark(p.y + 1, p.x) && isDark(p.y, p.x - 1) && isDark(p.y + 1, p.x - 1);

  bool innerTopRight(Point<int> p) =>
      isDark(p.y - 1, p.x) && isDark(p.y, p.x + 1) && isDark(p.y - 1, p.x + 1);
}
