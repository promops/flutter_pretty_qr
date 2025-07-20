part of 'pretty_qr_component.dart';

/// A base class for regions of the symbol not occupied by function patterns and
/// available for encoding of data and error correction codewords, and for
/// Version and Format information.
@sealed
abstract class PrettyQrEncodingRegionComponent implements PrettyQrComponent {}

/// The `Format Information` encoded pattern.
///
/// {@template pretty_qr_code.base.PrettyQrFormatInformation}
/// The encoded pattern containing information on symbol characteristics
/// essential to enable the remainder of the encoding region to be decoded.
/// {@endtemplate}
@sealed
@immutable
class PrettyQrFormatInformation implements PrettyQrEncodingRegionComponent {
  /// {@macro pretty_qr_code.base.PrettyQrVersion}
  @nonVirtual
  final PrettyQrVersion version;

  /// Creates a `Format Information` pattern.
  @literal
  const PrettyQrFormatInformation.of(this.version);

  /// The `Format Information` offset.
  static const offset = PrettyQrPositionDetectionPattern.dimension + 1;

  @override
  bool containsPoint(Point<num> another) {
    final x = another.x;
    final y = another.y;
    const timingPatternOffset = PrettyQrTimingPattern.offset;
    if (x == offset && y >= version.dimension - offset) return true;
    if (y == offset && x >= version.dimension - offset) return true;
    if (x <= offset && x != timingPatternOffset && y == offset) return true;
    if (y <= offset && y != timingPatternOffset && x == offset) return true;
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
    return other is PrettyQrFormatInformation && other.version == version;
  }
}

/// The `Version Information` encoded pattern.
///
/// {@template pretty_qr_code.base.PrettyQrVersionInformation}
/// **Note**: The Version Information areas are the `6x3` module block above
/// the Timing Pattern and immediately to the left of the top right Position
/// Detection Pattern Separator, and the `3x6` module block to the left of the
/// Timing Pattern and immediately above the lower left Position Detection
/// Pattern separator.
/// {@endtemplate}
@sealed
@immutable
class PrettyQrVersionInformation implements PrettyQrEncodingRegionComponent {
  /// {@macro pretty_qr_code.base.PrettyQrVersion}
  @nonVirtual
  final PrettyQrVersion version;

  /// Creates a `Version Information` pattern.
  @literal
  const PrettyQrVersionInformation.of(this.version);

  @override
  bool containsPoint(Point<num> another) {
    final x = another.x;
    final y = another.y;
    final dimension = version.dimension;
    if (x < 6 && y > dimension - 12 && y < dimension - 8) return true;
    if (y < 6 && x > dimension - 12 && x < dimension - 8) return true;
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
    return other is PrettyQrVersionInformation && other.version == version;
  }
}
