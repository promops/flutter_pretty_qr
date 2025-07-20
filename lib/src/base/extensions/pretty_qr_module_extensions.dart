import 'dart:math';

import 'package:meta/meta.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_version.dart';
import 'package:pretty_qr_code/src/base/components/pretty_qr_component.dart';

/// Extensions that apply to [Point<int>].
@internal
extension PrettyQrModuleExtension on Point<int> {
  /// Returns a [PrettyQrComponentType] for this module that depends on QR Code
  /// [version].
  PrettyQrComponentType resolveType(
    final PrettyQrVersion version,
  ) {
    // belongs to finder pattern
    final finderPattern = PrettyQrFinderPattern.of(version);
    if (finderPattern.containsPoint(this)) {
      return PrettyQrComponentType.finderPattern;
    }

    // belongs to alignment patterns
    final alignmentPatterns = PrettyQrAlignmentPattern.valuesOf(version);
    for (final pattern in alignmentPatterns) {
      if (pattern.containsPoint(this)) {
        return PrettyQrComponentType.alignmentPattern;
      }
    }

    // belongs to timing patterns
    final verticalTimingPattern = PrettyQrTimingPattern.verticalOf(version);
    if (verticalTimingPattern.containsPoint(this)) {
      return PrettyQrComponentType.timingPattern;
    }

    final horizontalTimingPattern = PrettyQrTimingPattern.horizontalOf(version);
    if (horizontalTimingPattern.containsPoint(this)) {
      return PrettyQrComponentType.timingPattern;
    }

    // belongs to separator pattern
    final separatorPattern = PrettyQrSeparatorPattern.of(version);
    if (separatorPattern.containsPoint(this)) {
      return PrettyQrComponentType.separatorPattern;
    }

    // belongs to version region
    final versionInformation = PrettyQrVersionInformation.of(version);
    if (versionInformation.containsPoint(this)) {
      return PrettyQrComponentType.versionInformation;
    }

    // belongs to format region
    final formatInformation = PrettyQrFormatInformation.of(version);
    if (formatInformation.containsPoint(this)) {
      return PrettyQrComponentType.formatInformation;
    }

    // otherwise belongs to encoding region
    return PrettyQrComponentType.encodingRegion;
  }
}
