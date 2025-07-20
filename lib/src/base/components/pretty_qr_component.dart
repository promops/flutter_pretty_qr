import 'dart:math';
import 'dart:collection';

import 'package:meta/meta.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_version.dart';

part 'pretty_qr_encoding_regions.dart';
part 'pretty_qr_function_patterns.dart';

/// A base class for QR Code pattern components.
@sealed
abstract class PrettyQrComponent {
  /// Whether pattern contains a [another] point.
  bool containsPoint(Point<num> another);
}

/// {@template pretty_qr_code.base.PrettyQrComponentType}
/// Distinguishes structural and data parts of a QR symbol.
/// {@endtemplate}
enum PrettyQrComponentType {
  /// {@macro pretty_qr_code.base.PrettyQrFinderPattern}
  finderPattern,

  /// {@macro pretty_qr_code.base.PrettyQrAlignmentPattern}
  alignmentPattern,

  /// {@macro pretty_qr_code.base.PrettyQrTimingPattern}
  timingPattern,

  /// {@macro pretty_qr_code.base.PrettyQrSeparatorPattern}
  separatorPattern,

  /// {@macro pretty_qr_code.base.PrettyQrVersionInformation}
  versionInformation,

  /// {@macro pretty_qr_code.base.PrettyQrFormatInformation}
  formatInformation,

  /// {@template pretty_qr_code.base.PrettyQrEncodingRegion}
  /// This region shall contain the symbol characters representing data, those
  /// representing error correction codewords, the format information and, where
  /// appropriate, the version information.
  /// {@endtemplate}
  encodingRegion;
}
