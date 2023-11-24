import 'dart:math';

import 'package:qr/qr.dart';
import 'package:meta/meta.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_module.dart';
import 'package:pretty_qr_code/src/base/pretty_qr_neighbour_direction.dart';

/// {@template pretty_qr_code.PrettyQrMatrix}
/// The QR code matrix consisting of an array of nominally square modules.
/// {@endtemplate}
@sealed
class PrettyQrMatrix extends Iterable<PrettyQrModule> {
  /// The size (side length) of the matrix.
  @nonVirtual
  final int dimension;

  /// The array of QR code modules.
  @visibleForTesting
  final List<PrettyQrModule> modules;

  /// Each Position Detection Pattern may be viewed as three superimposed
  /// concentric squares and is constructed of dark `7x7` modules, light `5x5`
  /// modules and dark `3x3` modules.
  static const kFinderPatternDimension = 7;

  /// Creates a QR matrix.
  @literal
  const PrettyQrMatrix({
    required this.modules,
    required this.dimension,
  });

  /// Creates a qr matrix from [QrImage].
  factory PrettyQrMatrix.fromQrImage(
    final QrImage qrImage,
  ) {
    return PrettyQrMatrix(
      modules: List.generate(
        qrImage.moduleCount * qrImage.moduleCount,
        (index) {
          final col = index % qrImage.moduleCount;
          final row = index ~/ qrImage.moduleCount;
          return PrettyQrModule(col, row, isDark: qrImage.isDark(row, col));
        },
        growable: false,
      ),
      dimension: qrImage.moduleCount,
    );
  }

  /// Returns the value of the module at position [x], [y] or `null` if the
  /// coordinate is outside the matrix.
  @useResult
  PrettyQrModule? getModule(int x, int y) {
    if (y < 0 || y >= dimension) return null;
    if (x < 0 || x >= dimension) return null;

    // ignore: avoid-unsafe-collection-methods
    return modules[y * dimension + x];
  }

  /// Set `isDark` equals to `false` fot the module at position [x], [y].
  @nonVirtual
  void removeDarkAt(int x, int y) {
    final module = getModule(x, y);
    modules[y * dimension + x] = module!.copyWith(isDark: false);
  }

  /// Returns the directions to the nearest neighbours of the [point].
  @nonVirtual
  Set<PrettyQrNeighbourDirection> getNeighboursDirections(
    final Point<int> point,
  ) {
    return {
      for (final value in PrettyQrNeighbourDirection.values)
        if (getModule(point.x + value.x, point.y + value.y)?.isDark ?? false)
          value,
    };
  }

  /// Returns `true` if the point is part of one of three Finder Pattern
  /// components.
  @nonVirtual
  bool isFinderPatternPoint(Point<int> point) {
    const pSide = kFinderPatternDimension;
    if (point.x < pSide && point.y < pSide) return true;
    if (point.x < pSide && point.y >= dimension - pSide) return true;
    if (point.x >= dimension - pSide && point.y < pSide) return true;
    return false;
  }

  @override
  Iterator<PrettyQrModule> get iterator {
    return modules.iterator;
  }
}
