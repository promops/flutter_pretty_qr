part of 'pretty_qr_component.dart';

/// A base class for QR Code overhead component of the symbol required for
/// location of the symbol or identification of its characteristics to assist in
/// decoding.
@sealed
abstract class PrettyQrFunctionPatternComponent implements PrettyQrComponent {}

/// The QR Code `Position Detection Pattern`.
@sealed
@immutable
class PrettyQrPositionDetectionPattern extends Rectangle<int>
    implements PrettyQrFunctionPatternComponent {
  /// The `Position Detection Pattern` dimension.
  static const dimension = 7;

  /// Creates a `Position Detection Pattern`.
  @literal
  const PrettyQrPositionDetectionPattern(
    final int left,
    final int top,
  ) : super(left, top, dimension - 1, dimension - 1);
}

/// The QR Code `Finder Pattern`.
///
/// {@template pretty_qr_code.base.PrettyQrFinderPattern}
/// The finder pattern shall consist of three identical `Position
/// Detection Patterns` located at the upper left, upper right and lower left
/// corners of the symbol.
///
/// **Note**: Each `Position Detection Pattern` may be viewed as three
/// superimposed concentric squares and is constructed of dark `7x7` modules,
/// light `5x5` modules and dark `3x3` modules.
/// {@endtemplate}
@sealed
@immutable
class PrettyQrFinderPattern implements PrettyQrFunctionPatternComponent {
  /// {@macro pretty_qr_code.base.PrettyQrVersion}
  @nonVirtual
  final PrettyQrVersion version;

  /// Creates a finder pattern.
  @literal
  const PrettyQrFinderPattern.of(this.version);

  /// Return rectangle of left top `Position Detection Pattern`.
  Set<PrettyQrPositionDetectionPattern> get positionDetectionPatterns {
    const patternDimension = PrettyQrPositionDetectionPattern.dimension;
    return {
      const PrettyQrPositionDetectionPattern(0, 0),
      PrettyQrPositionDetectionPattern(version.dimension - patternDimension, 0),
      PrettyQrPositionDetectionPattern(0, version.dimension - patternDimension),
    };
  }

  @override
  bool containsPoint(Point<num> another) {
    for (final pattern in positionDetectionPatterns) {
      if (pattern.containsPoint(another)) return true;
    }
    return false;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, version);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is PrettyQrFinderPattern && other.version == version;
  }
}

/// The QR Code `Alignment Pattern`.
///
/// {@template pretty_qr_code.base.PrettyQrAlignmentPattern}
/// Each `Alignment Pattern` may be viewed as three superimposed
/// concentric squares and is constructed of dark `5x5` modules, light `3x3`
/// modules and a single central dark module.
///
/// **Note**: For example, in a `Version 2` positions indicates values `6`
/// and `18`. The Alignment Patterns, therefore, are to be centered on (row,
/// column) position `(18,18)`. Note that the coordinates `(6,6)`, `(6,18)`,
/// `(18,6)` are occupied by Position Detection Patterns and are not therefore
/// used for Alignment Patterns.
/// {@endtemplate}
@sealed
@immutable
class PrettyQrAlignmentPattern extends Rectangle<int>
    implements PrettyQrFunctionPatternComponent {
  /// The `Position Detection Pattern` dimension.
  static const dimension = 5;

  /// The singleton that implements the `Alignment Patterns` cache by version.
  ///
  /// The cache is used internally by [PrettyQrAlignmentPattern] and should
  /// generally not be accessed directly.
  ///
  /// The alignment patterns cache is created during first call the
  /// [PrettyQrAlignmentPattern.valuesOf] method with a specific version.
  @internal
  @visibleForTesting
  // ignore: avoid-missing-enum-constant-in-map, used to reduce the number of calculations.
  static final patternsByVersionCache = {
    PrettyQrVersion.version01: <PrettyQrAlignmentPattern>{},
  };

  /// Creates an `Alignment Patter`.
  @literal
  const PrettyQrAlignmentPattern(
    final int left,
    final int top,
  ) : super(left, top, dimension - 1, dimension - 1);

  /// The center point of this pattern.
  @nonVirtual
  Point<int> get center {
    return Point(left + width ~/ 2, top + height ~/ 2);
  }

  /// Returns the list of points that are the center of the Alignment Patterns.
  static Set<PrettyQrAlignmentPattern> valuesOf(PrettyQrVersion version) {
    if (patternsByVersionCache.containsKey(version)) {
      return patternsByVersionCache[version]!;
    }

    final finderPattern = PrettyQrFinderPattern.of(version);
    return patternsByVersionCache[version] = UnmodifiableSetView({
      for (final row in version.alignmentPatternsPlacement)
        for (final col in version.alignmentPatternsPlacement)
          if (!finderPattern.containsPoint(Point(col, row)))
            PrettyQrAlignmentPattern(col - 2, row - 2),
    });
  }
}

/// The QR Code alternating sequence of dark and light modules enabling module
/// coordinates in the symbol to be determined.
///
/// {@template pretty_qr_code.base.PrettyQrTimingPattern}
/// The horizontal and vertical `Timing Patterns` respectively consist of a
/// one module wide row or column of alternating dark and light modules,
/// commencing and ending with a dark module.
///
/// **Note**: The horizontal `Timing Pattern` runs across row `6` of the
/// symbol between the separators for the upper `Position Detection Patterns`;
/// the vertical `Timing Pattern` similarly runs down column `6` of the symbol
/// between the separators for the left-hand `Position Detection Patterns`.
/// {@endtemplate}
@sealed
@immutable
class PrettyQrTimingPattern extends Rectangle<int>
    implements PrettyQrFunctionPatternComponent {
  /// The `Timing Pattern` offset.
  static const offset = PrettyQrPositionDetectionPattern.dimension - 1;

  /// The `Timing Pattern` sides margin.
  static const sidesMargin = PrettyQrPositionDetectionPattern.dimension + 1;

  /// Creates a `Timing Pattern` rectangle.
  @literal
  const PrettyQrTimingPattern._(
    super.left,
    super.top,
    super.width,
    super.height,
  );

  /// Creates a vertical timing pattern.
  factory PrettyQrTimingPattern.verticalOf(
    final PrettyQrVersion version,
  ) {
    return PrettyQrTimingPattern._(
      offset,
      sidesMargin,
      0,
      version.dimension - sidesMargin * 2 - 1,
    );
  }

  /// Creates a horizontal timing pattern.
  factory PrettyQrTimingPattern.horizontalOf(
    final PrettyQrVersion version,
  ) {
    return PrettyQrTimingPattern._(
      sidesMargin,
      offset,
      version.dimension - sidesMargin * 2 - 1,
      0,
    );
  }
}

/// The `separator` pattern for Position Detection Patterns.
///
/// {@template pretty_qr_code.base.PrettyQrSeparatorPattern}
/// A one-module wide Separator is placed between each `Position Detection
/// Pattern` and `Encoding Region`.
/// {@endtemplate}
@sealed
@immutable
class PrettyQrSeparatorPattern implements PrettyQrFunctionPatternComponent {
  /// {@macro pretty_qr_code.base.PrettyQrVersion}
  @nonVirtual
  final PrettyQrVersion version;

  /// Creates a `separator` pattern.
  @literal
  const PrettyQrSeparatorPattern.of(this.version);

  @override
  bool containsPoint(Point<num> another) {
    final x = another.x;
    final y = another.y;
    final dimension = version.dimension;
    if (x == 7 && (y < 8 || y > dimension - 9)) return true;
    if (y == 7 && (x < 8 || x > dimension - 9)) return true;
    if (x < 8 && y == dimension - 8 || y < 8 && x == dimension - 8) return true;
    return false;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, version);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is PrettyQrSeparatorPattern && other.version == version;
  }
}
