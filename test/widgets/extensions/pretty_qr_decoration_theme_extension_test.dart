import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pretty_qr_code/src/widgets/pretty_qr_theme.dart';
import 'package:pretty_qr_code/src/painting/pretty_qr_quiet_zone.dart';
import 'package:pretty_qr_code/src/painting/shapes/pretty_qr_smooth_symbol.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration.dart';
import 'package:pretty_qr_code/src/painting/decoration/pretty_qr_decoration_image.dart';

import 'package:pretty_qr_code/src/widgets/extensions/pretty_qr_decoration_theme_extension.dart';

void main() {
  group('PrettyQrDecorationThemeExtension', () {
    group('applyDefaults', () {
      test(
        'returns theme decoration when current decoration is null',
        () {
          // arrange
          const prettyQrTheme = PrettyQrTheme(
            decoration: PrettyQrDecoration(
              image: PrettyQrDecorationImage(
                image: AssetImage('images/flutter.png'),
              ),
              shape: PrettyQrSmoothSymbol(color: Colors.green),
              quietZone: PrettyQrQuietZone.pixels(256),
            ),
          );

          // act
          final mergedDecoration = null.applyDefaults(prettyQrTheme);

          // assert
          expect(
            mergedDecoration.shape,
            equals(prettyQrTheme.decoration.shape),
          );
          expect(
            mergedDecoration.background,
            equals(prettyQrTheme.decoration.background),
          );
          expect(
            mergedDecoration.image,
            equals(prettyQrTheme.decoration.image),
          );
          expect(
            mergedDecoration.quietZone,
            equals(prettyQrTheme.decoration.quietZone),
          );
        },
      );

      test(
        'correctly merged current decoration with theme decoration',
        () {
          // arrange
          const decoration = PrettyQrDecoration(
            shape: PrettyQrSmoothSymbol(color: Colors.yellow),
          );
          const prettyQrTheme = PrettyQrTheme(
            decoration: PrettyQrDecoration(
              image: PrettyQrDecorationImage(
                image: AssetImage('images/flutter.png'),
              ),
              background: Colors.red,
              shape: PrettyQrSmoothSymbol(color: Colors.green),
              quietZone: PrettyQrQuietZone.pixels(256),
            ),
          );

          // act
          final mergedDecoration = decoration.applyDefaults(prettyQrTheme);

          // assert
          expect(
            mergedDecoration.shape,
            equals(decoration.shape),
          );
          expect(
            mergedDecoration.background,
            equals(prettyQrTheme.decoration.background),
          );
          expect(
            mergedDecoration.image,
            equals(prettyQrTheme.decoration.image),
          );
          expect(
            mergedDecoration.quietZone,
            equals(prettyQrTheme.decoration.quietZone),
          );
        },
      );
    });
  });
}
