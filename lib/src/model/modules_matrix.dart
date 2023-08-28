import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

@immutable
class ModulesMatrix {
  final List<List<bool>> _modules;

  factory ModulesMatrix(QrImage image) {
    print(image.moduleCount);
    return ModulesMatrix._(image);
  }

  // ignore: invalid_use_of_visible_for_testing_member
  ModulesMatrix._(final QrImage image) : _modules = [...image.qrModules.map((e) => e.cast())];

  void subtractRect(Rect rect, double dimension) {
    for (int x = 0; x < _modules.length; ++x) {
      for (int y = 0; y < _modules.length; ++y) {
        final dotRect = Rect.fromLTWH(
          x * dimension,
          y * dimension,
          dimension,
          dimension,
        );

        if (rect.overlaps(dotRect)) {
          _modules[x][y] = false;
        }
      }
    }
  }

  bool isDark(int x, int y) {
    try {
      return _modules[x][y] == true;
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

  bool hasLeftNeighbour(Point<int> p) => isDark(p.x - 1, p.y);

  bool hasRighttNeighbour(Point<int> p) => isDark(p.x + 1, p.y);

  bool hasTopNeighbour(Point<int> p) => isDark(p.x, p.y + 1);

  bool hasBottomNeighbour(Point<int> p) => isDark(p.x, p.y - 1);

  Set<Alignment> getNeighbours(Point<int> p) {
    return {
      if (isDark(p.y, p.x - 1)) Alignment.centerLeft,
      if (isDark(p.y, p.x + 1)) Alignment.centerRight,
      if (isDark(p.y - 1, p.x)) Alignment.topCenter,
      if (isDark(p.y + 1, p.x)) Alignment.bottomCenter,
    };
  }
}
