import 'dart:math';

import 'package:meta/meta.dart';

import 'package:pretty_qr_code/src/base/components/pretty_qr_component.dart';

/// {@template pretty_qr_code.base.PrettyQrModule}
/// The QR code module.
/// {@endtemplate}
@sealed
@immutable
class PrettyQrModule extends Point<int> {
  /// Returns `true` if the point is dark.
  @nonVirtual
  final bool isDark;

  /// The QR Code pattern to which this module belongs.
  @nonVirtual
  final PrettyQrComponentType type;

  /// Creates a QR module.
  @literal
  const PrettyQrModule(
    super.x,
    super.y, {
    required this.type,
    required this.isDark,
  });

  /// {@macro pretty_qr_code.base.PrettyQrFinderPattern}
  @pragma('vm:prefer-inline')
  bool get isFinderPattern {
    return type == PrettyQrComponentType.finderPattern;
  }

  /// {@macro pretty_qr_code.base.PrettyQrAlignmentPattern}
  @pragma('vm:prefer-inline')
  bool get isAlignmentPattern {
    return type == PrettyQrComponentType.alignmentPattern;
  }

  /// {@macro pretty_qr_code.base.PrettyQrTimingPattern}
  @pragma('vm:prefer-inline')
  bool get isTimingPattern {
    return type == PrettyQrComponentType.timingPattern;
  }

  /// {@macro pretty_qr_code.base.PrettyQrSeparatorPattern}
  @pragma('vm:prefer-inline')
  bool get isSeparatorPattern {
    return type == PrettyQrComponentType.separatorPattern;
  }

  /// {@macro pretty_qr_code.base.PrettyQrVersionInformation}
  @pragma('vm:prefer-inline')
  bool get isVersionInformation {
    return type == PrettyQrComponentType.versionInformation;
  }

  /// {@macro pretty_qr_code.base.PrettyQrFormatInformation}
  @pragma('vm:prefer-inline')
  bool get isFormatInformation {
    return type == PrettyQrComponentType.formatInformation;
  }

  /// {@macro pretty_qr_code.base.PrettyQrEncodingRegion}
  @pragma('vm:prefer-inline')
  bool get isEncodingRegion {
    return type == PrettyQrComponentType.encodingRegion;
  }

  /// Returns a blank copy of this [PrettyQrModule].
  @useResult
  @pragma('vm:prefer-inline')
  PrettyQrModule toBlank() {
    return isDark ? PrettyQrModule(x, y, type: type, isDark: false) : this;
  }

  /// Creates a copy of this [PrettyQrModule] but with the given fields
  /// replaced with the new values.
  @factory
  @useResult
  @Deprecated(
    'Please use `toBlank` instead. '
    'This feature was deprecated after v4.0.0.',
  )
  // ignore: avoid-incomplete-copy-with, intentionally omitted.
  PrettyQrModule copyWith({
    final bool? isDark,
  }) {
    return PrettyQrModule(x, y, type: type, isDark: isDark ?? this.isDark);
  }

  @override
  int get hashCode {
    return Object.hash(super.hashCode, isDark, type);
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) {
      return true;
    }

    return other is PrettyQrModule &&
        super == other &&
        other.type == type &&
        other.isDark == isDark;
  }
}
