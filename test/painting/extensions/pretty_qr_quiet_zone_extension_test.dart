import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:pretty_qr_code/src/base/pretty_qr_matrix.dart';
import 'package:pretty_qr_code/src/base/pretty_qr_version.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_quiet_zone.dart';
import 'package:pretty_qr_code/src/rendering/pretty_qr_painting_context.dart';

import 'package:pretty_qr_code/src/painting/extensions/pretty_qr_quiet_zone_extension.dart';

void main() {
  // The QR code size for tests.
  const testQRSize = 105.0;

  // The QR code version for tests.
  const testQRVersion = PrettyQrVersion.version08;

  // The painting context for tests.
  final testContext = PrettyQrPaintingContext(
    Canvas(PictureRecorder()),
    Offset.zero & const Size.square(testQRSize),
    matrix: const PrettyQrMatrix(
      modules: [],
      version: testQRVersion,
    ),
  );

  group('PrettyQrQuietZoneExtension', () {
    test(
      'returns zero when quiet zone is null',
      () {
        // act
        final quietZoneWidth = null.resolveWidth(
          testContext,
        );

        // assert
        expect(quietZoneWidth, isZero);
      },
    );

    test(
      'returns correct width when quiet zone is pixels based',
      () {
        // arrange
        const quietZone = PrettyQrPixelsQuietZone(16);

        // act
        final quietZoneWidth = quietZone.resolveWidth(
          testContext,
        );

        // assert
        expect(quietZoneWidth, equals(quietZone.value));
      },
    );

    test(
      'returns correct width when quiet zone is pixels based and greater than '
      'quarter QR code size',
      () {
        // arrange
        const quietZone = PrettyQrPixelsQuietZone(
          testQRSize / 4 + 1,
        );

        // act
        final quietZoneWidth = quietZone.resolveWidth(
          testContext,
        );

        // assert
        expect(quietZoneWidth, equals(testQRSize / 4));
      },
    );

    test(
      'returns correct width when quiet zone is module based and greater than '
      'quarter QR code size',
      () {
        // arrange
        final quietZone = PrettyQrModulesQuietZone(
          testQRVersion.dimension ~/ 4 + 1,
        );

        // act
        final quietZoneWidth = quietZone.resolveWidth(
          testContext,
        );

        // assert
        expect(quietZoneWidth, equals(testQRSize / 4));
      },
    );
  });
}
