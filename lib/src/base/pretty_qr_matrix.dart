import 'dart:math';
import 'dart:collection';

import 'package:qr/qr.dart';
import 'package:meta/meta.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_module.dart';
import 'package:pretty_qr_code/src/base/pretty_qr_version.dart';
import 'package:pretty_qr_code/src/base/pretty_qr_neighbour_direction.dart';
import 'package:pretty_qr_code/src/base/components/pretty_qr_component.dart';
import 'package:pretty_qr_code/src/base/extensions/pretty_qr_module_extensions.dart';

/// {@template pretty_qr_code.base.PrettyQrMatrix}
/// The QR code matrix consisting of an array of nominally square modules.
/// {@endtemplate}
@sealed
@immutable
class PrettyQrMatrix extends Iterable<PrettyQrModule> {
  /// The size of the symbol represented in terms of its position in the
  /// sequence of permissible sizes from `21x21` modules (Version 1) to
  /// `177x177` (Version 40) modules.
  @nonVirtual
  final PrettyQrVersion version;

  /// The array of QR code modules.
  @visibleForTesting
  final List<PrettyQrModule> modules;

  /// Creates a QR matrix.
  @literal
  const PrettyQrMatrix({
    required this.version,
    required this.modules,
  });

  /// {@macro pretty_qr_code.base.PrettyQrMaskedMatrix}
  @internal
  @experimental
  factory PrettyQrMatrix.masked(
    PrettyQrMatrix parent, {
    Rectangle<int>? clip,
    Set<PrettyQrComponentType> exclude,
  }) = _PrettyQrMaskedMatrix;

  /// Creates a qr matrix from [QrImage].
  factory PrettyQrMatrix.fromQrImage(
    final QrImage qrImage,
  ) {
    final version = PrettyQrVersion.of(
      qrImage.typeNumber,
    );

    final modules = List.generate(
      version.dimension * version.dimension,
      (index) {
        final point = Point(
          index % version.dimension,
          index ~/ version.dimension,
        );

        return PrettyQrModule(
          point.x,
          point.y,
          type: point.resolveType(version),
          isDark: qrImage.isDark(point.y, point.x),
        );
      },
      growable: false,
    );

    return PrettyQrMatrix(
      version: version,
      modules: modules,
    );
  }

  /// Returns the size (side length) of the matrix.
  @nonVirtual
  @pragma('vm:prefer-inline')
  int get dimension {
    return version.dimension;
  }

  @override
  Iterator<PrettyQrModule> get iterator {
    return modules.iterator;
  }

  /// Returns the list of the existing `Alignment Patterns`.
  ///
  /// {@macro pretty_qr_code.base.PrettyQrModuleType.alignmentPattern}
  Set<PrettyQrAlignmentPattern> get alignmentPatterns {
    return UnmodifiableSetView({
      ...PrettyQrAlignmentPattern.valuesOf(version).where(containsRectCorners),
    });
  }

  /// Returns the list of the existing `Position Detection Patterns`.
  ///
  /// {@macro pretty_qr_code.base.PrettyQrModuleType.finderPattern}
  Set<PrettyQrPositionDetectionPattern> get positionDetectionPatterns {
    final finderPattern = PrettyQrFinderPattern.of(version);
    return UnmodifiableSetView({
      ...finderPattern.positionDetectionPatterns.where(containsRectCorners),
    });
  }

  /// Returns `true` if a module at position [x], [y] has `isDark` value equals
  /// to `true`.
  bool hasModuleAt(int x, int y) {
    final module = getModuleAt(x, y);
    return module != null && module.isDark;
  }

  /// {@template pretty_qr_code.PrettyQrMatrix.getModuleAt}
  /// Returns the value of the module at position [x], [y] or `null` if the
  /// coordinate is outside the matrix.
  /// {@endtemplate}
  @useResult
  PrettyQrModule? getModuleAt(int x, int y) {
    if (y < 0 || y >= version.dimension) return null;
    if (x < 0 || x >= version.dimension) return null;

    final moduleIndex = y * dimension + x;
    return modules[moduleIndex];
  }

  /// {@macro pretty_qr_code.PrettyQrMatrix.getModuleAt}
  @Deprecated(
    'Please use `getModuleAt` instead. '
    'This feature was deprecated after v4.0.0.',
  )
  PrettyQrModule? getModule(int x, int y) {
    return getModuleAt(x, y);
  }

  /// Set `isDark` equals to `false` fot the module at position [x], [y].
  @nonVirtual
  @Deprecated('This feature was deprecated after v4.0.0.')
  void removeDarkAt(int x, int y) {
    final module = getModuleAt(x, y)!;
    modules[y * version.dimension + x] = module.toBlank();
  }

  /// Tests whether [rect] corners is inside of QR code matrix.
  @nonVirtual
  bool containsRectCorners(Rectangle<int> rect) {
    if (!hasModuleAt(rect.topLeft.x, rect.topLeft.y)) return false;
    if (!hasModuleAt(rect.topRight.x, rect.topRight.y)) return false;
    if (!hasModuleAt(rect.bottomLeft.x, rect.bottomLeft.y)) return false;
    if (!hasModuleAt(rect.bottomRight.x, rect.bottomRight.y)) return false;
    return true;
  }

  /// Returns the directions to the nearest neighbours of the [point].
  @nonVirtual
  Set<PrettyQrNeighbourDirection> getNeighboursDirections(
    final Point<int> point,
  ) {
    return {
      for (final value in PrettyQrNeighbourDirection.values)
        if (hasModuleAt(point.x + value.x, point.y + value.y)) value,
    };
  }

  @override
  int get hashCode {
    return Object.hashAll([version, ...modules]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PrettyQrMatrix) return false;

    if (other.version != version) return false;
    if (other.modules.length != modules.length) return false;

    for (int index = 0; index < modules.length; ++index) {
      if (other.modules[index] != modules[index]) return false;
    }

    return true;
  }
}

/// {@template pretty_qr_code.base.PrettyQrMaskedMatrix}
/// A QR code matrix wrapper that excludes specified components.
/// {@endtemplate}
@sealed
@immutable
class _PrettyQrMaskedMatrix extends PrettyQrMatrix {
  /// The source matrix being wrapped.
  @nonVirtual
  final PrettyQrMatrix parent;

  /// Rectangle defining the clipping area.
  @nonVirtual
  final Rectangle<int>? clip;

  /// Indicates which component modules are excluded from the QR code matrix.
  @nonVirtual
  final Set<PrettyQrComponentType> exclude;

  /// {@macro pretty_qr_code.base.PrettyQrMaskedMatrix}
  _PrettyQrMaskedMatrix(
    this.parent, {
    this.clip,
    this.exclude = const {},
  }) : super(version: parent.version, modules: parent.modules);

  @override
  Iterator<PrettyQrModule> get iterator {
    return modules.map((module) => getModuleAt(module.x, module.y)!).iterator;
  }

  @override
  PrettyQrModule? getModuleAt(int x, int y) {
    final module = parent.getModuleAt(x, y);
    if (module == null) return module;

    late final exluded = exclude.contains(module.type);
    late final clipped = clip?.containsPoint(module) ?? false;

    return clipped || exluded ? module.toBlank() : module;
  }

  @override
  int get hashCode {
    return Object.hash(parent, clip, exclude);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! _PrettyQrMaskedMatrix) return false;

    if (other.clip != clip) return false;
    for (final type in other.exclude) {
      if (!exclude.contains(type)) return false;
    }

    return parent == other;
  }
}
